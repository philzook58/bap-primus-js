open Core_kernel

open Js_of_ocaml_toplevel
let () = JsooTop.initialize ()
let () = Sys.interactive := false

(* https://github.com/ocsigen/js_of_ocaml/blob/master/toplevel/examples/eval/eval.ml 
*)
let execute code =
  let code = Js_of_ocaml.Js.to_string code in
  let buffer = Buffer.create 100 in
  let formatter = Format.formatter_of_buffer buffer in
  JsooTop.execute true formatter code;
  Js_of_ocaml.Js.string (Buffer.contents buffer)

let () =
  Js_of_ocaml.Js.export
    "evaluator"
    (object%js
        val execute = execute
    end)


let () = match Bap_main.init ~requires:["semantics"]
~argv:[|"bap"; "show-lisp"; "foo"; "--primus-lisp-load=test";  "--primus-lisp-add=/static/" |] 
~log:(`Formatter Format.std_formatter) ~err:Format.std_formatter 
~library:["/static/"] ()
 with
    | Ok () -> ()
    | Error err -> Bap_main.Extension.Error.pp Format.std_formatter err



(**
Oooh ~library sounds useful 
The feature primus-lisp should depend on itself I think
most other things do.

bap list features
Is the stuff that fgoes in ~requires


*)
  (*
loader.debug> Linking library bap_abi
loader.debug> Linking library bap_api
loader.debug> Linking library bap_c
loader.debug> Linking library bap_strings
loader.debug> Linking library bap_primus
loader.debug> Linking library taint
loader.debug> Linking library primus_taint_plugin
loader.debug> Linking library bap_plugin_primus_taint
loader.info> Loaded primus-taint from "/home/philip/.opam/4.12.1/lib/bap/primus_taint.plugin"
  *)