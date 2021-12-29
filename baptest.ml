
(*
ocamlfind ocamlc -package bap -package core_kernel -linkpkg -linkall baptest.ml 
js_of_ocaml +dynlink.js +toplevel.js +zarith_stubs_js/runtime.js +zarith_stubs_js/biginteger.js \
  +base/base_internalhash_types/runtime.js +base/runtime.js +time_now/runtime.js +bin_prot/runtime.js \
  +ppx_expect/collector/runtime.js +base_bigstring/runtime.js +core_kernel/strftime.js +core_kernel/runtime.js \
  +bigstringaf/runtime.js --linkall --extern-fs --toplevel a.out
*)

open Core_kernel
open Bap.Std
open Bap_primus.Std
open Bap_core_theory
(* let () = match Bap_main.init ~requires:[] ~log:(`Formatter Format.std_formatter) ~err:Format.std_formatter () with
    | Ok () -> ()
    | Error s -> failwith "Something has gone awry"
*)
let load_program paths features project =
  match Primus.Lisp.Load.program ~paths project features with
  | Ok prog -> prog
  | Error err ->
    let err = Format.asprintf "%a" Primus.Lisp.Load.pp_error err in
    invalid_arg err


let prog = load_program ["."] ["mytest"] (Project.empty Theory.Target.unknown)

module Semantics_primitives = Primus_lisp_semantic_primitives

module Semantics = struct
  open Bap_core_theory
  open KB.Syntax
  module Lisp = Primus.Lisp
  module Insn = Disasm_expert.Basic.Insn

  let (:=) p x v = KB.Value.put p v x
  let empty = KB.Value.empty Theory.Source.cls
  let pack prog = List.fold ~init:empty [
      Theory.Source.language := Lisp.Unit.language;
      Lisp.Semantics.program := prog;
    ] ~f:(|>)

  let load_lisp_unit ~paths ~features =
    KB.Rule.(begin
        declare "primus-lisp-program" |>
        require Theory.Label.unit          |>
        require Theory.Unit.target         |>
        provide Lisp.Semantics.program |>
        comment "loads a program to the Lisp unit"
      end);
    KB.promise Theory.Unit.source @@ fun unit ->
    Lisp.Unit.is_lisp unit >>= function
    | false -> !!empty
    | true ->
      KB.collect Theory.Unit.target unit >>| fun target ->
      pack @@
      load_program paths features @@
      Project.empty target

  let args_of_ops (module CT : Theory.Core) target insn =
    let bits = Theory.Target.bits target in
    let word = Theory.Bitv.define bits in
    let bitv x = Bitvec.(int64 x mod modulus bits) in
    Insn.ops insn |> Array.to_list |>
    List.map ~f:(function
        | Op.Fmm _ -> CT.unk word >>| Theory.Value.forget
        | Op.Imm x ->
          let x = bitv (Imm.to_int64 x) in
          CT.int word x >>| Theory.Value.forget >>| fun v ->
          KB.Value.put Lisp.Semantics.static v (Some x)
        | Op.Reg v ->
          let name = Reg.name v in
          let reg = match Theory.Target.var target name with
            | None -> Theory.Var.forget @@ Theory.Var.define word name
            | Some v -> v in
          CT.var reg >>| fun v ->
          KB.Value.put Lisp.Semantics.symbol v (Some name)) |>
    KB.List.all

  let translate_ops_to_args () =
    KB.Rule.(begin
        declare "translate-ops-to-lisp-args" |>
        require Insn.slot |>
        provide Lisp.Semantics.args |>
        comment "translates instruction operands to lisp arguments"
      end);
    KB.promise Lisp.Semantics.args @@ fun this ->
    (* let*? insn = KB.collect Insn.slot this in *)
    Theory.current >>= fun theory ->
    Theory.Label.target this >>= fun target ->
    args_of_ops theory target insn >>| Option.some

  let translate_opcode_to_name () =
    KB.Rule.(begin
        declare "translate-opcode-to-lisp-name" |>
        require Insn.slot |>
        provide Lisp.Semantics.name |>
        comment "translates opcode to the lisp definition name"
      end);
    KB.promise Lisp.Semantics.name @@ fun this ->
    KB.collect Insn.slot this >>|? fun insn ->
    KB.Name.create ~package:(Insn.encoding insn) (Insn.name insn) |>
    Option.some

  let strip_lisp_extension = String.chop_suffix ~suffix:".lisp"

  let collect_features folder =
    Sys.readdir folder |> Array.to_list |>
    List.filter_map ~f:strip_lisp_extension
(*
  let default_paths = let (/) = Filename.concat in Configuration.[
      datadir / "primus" / "semantics";
      sysdatadir / "primus" / "semantics";
    ]

  let check_user_provided paths =
    match List.find paths ~f:(Fn.non is_folder) with
    | None -> ()
    | Some path ->
      invalid_argf "unable to load semantics from %S, \
                    the path must exist and be a folder" path ()
*)
let is_folder p = Sys.file_exists p && Sys.is_directory p
  let load_lisp_sources paths =
    (* check_user_provided paths; *)
    let paths = List.filter ~f:is_folder (paths) in
    let features = "core"::List.concat_map ~f:collect_features paths in
    let paths = paths(*  @ library_paths *)in
    let prog t =
      pack@@load_program paths features@@Project.empty t in
    KB.promise Theory.Unit.source @@ fun this ->
    Primus.Lisp.Unit.is_lisp this >>= function
    | true -> !!empty
    | false ->
      KB.collect Theory.Unit.target this >>| prog

  let enable_lifter sites =
    translate_ops_to_args ();
    translate_opcode_to_name ();
    load_lisp_sources sites;
end

let () = Semantics_primitives.provide ()
let () = Semantics_primitives.enable_extraction ()
let () = Semantics.load_lisp_unit ~paths:["."] ~features:["core"; "mytest"]
let () = Primus.Lisp.Semantics.enable ()
let () = Semantics.enable_lifter ["."]

let show target name =
    Printf.printf "got here\n%!";
let slots = [] in
let open KB.Syntax in
  let pp = match List.concat slots with
    | [] -> KB.Value.pp
    | ss -> KB.Value.pp_slots ss in
  Toplevel.try_exec @@ begin
    Printf.printf "got here2\n%!";
    Primus.Lisp.Unit.create target >>= fun unit ->
    Printf.printf "got thern%!";
    KB.Object.scoped Theory.Program.cls @@ fun obj ->
    KB.sequence [
      KB.provide Theory.Label.unit obj (Some unit);
      (* KB.provide Theory.Label.addr obj addr; *)
      KB.provide Primus.Lisp.Semantics.name obj (Some name);
    ] >>= fun () ->
    Printf.printf "got hare\n%!";
    KB.collect Theory.Semantics.slot obj >>| fun sema ->
    Printf.printf "got stuff\n%!";
    Format.eprintf "%a:@ %a@." KB.Name.pp name pp sema
  end

let () = match show Theory.Target.unknown (KB.Name.create "foo") with
        | Ok _ -> ()
        | Error e -> failwith (KB.Conflict.to_string e)
