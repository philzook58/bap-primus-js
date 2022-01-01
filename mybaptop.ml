open Bap_plugins.Std
(*
open Js_of_ocaml_toplevel
let () = JsooTop.initialize ()
*)
let install_printer printer =
  Topdirs.dir_install_printer Format.err_formatter
    (Longident.parse printer)

let install_printers () =
  Core_kernel.Pretty_printer.all () |>
  List.iter install_printer

let main () =
  let module Bap_std_is_required = Bap.Std in
  let module Core_kernel_is_required = Core_kernel in
  Sys.interactive := false;
  let loader = Topdirs.dir_load Format.err_formatter in
  setup_dynamic_loader loader;
  install_printers ();
  match Bap_main.init ~argv: [|"baptop"|] ~log:(`Formatter Format.std_formatter) ~err:Format.std_formatter  () with
  | Ok () -> ()
  | Error failed ->
    Format.eprintf "Failed to initialize BAP: %a@\n%!"
      Bap_main.Extension.Error.pp failed;
    exit 1


let () = main ()