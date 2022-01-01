(*open Core_kernel
open Bap.Std
open Bap_primus.Std
open Bap_core_theory *)
open Bap_plugins.Std


let () = 
  let module Bap_std_is_required = Bap.Std in
  let module Core_kernel_is_required = Core_kernel in
  let loader = Topdirs.dir_load Format.err_formatter in
    setup_dynamic_loader loader;
    match Bap_main.init (*~requires:["bap-abi"; "primus-lisp"] *) ~log:(`Formatter Format.std_formatter) ~err:Format.std_formatter [|"baptop"|] () with
    | Ok () -> ()
    | Error s -> failwith "Something has gone awry"