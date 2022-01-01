(*open Core_kernel *)
(* let () = print_endline "hello" *)
let () = Array.iter (fun d -> print_endline d ) (Sys.readdir "/static/")
(*
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
    *)