    (* 
    https://github.com/BinaryAnalysisPlatform/bap/blob/97fb7fa6a8a90faeae2b077d8ad59b8b882d7c32/lib/bap_bundle/bap_bundle.ml
    *)
    let zip = Zip.open_in "./abi.plugin"
    (* let manifest = "MANIFEST.scm"
    let data = Zip.read_entry zip (Zip.find_entry zip manifest)

    let () = print_endline data *)
    let entry = (Zip.find_entry zip "bap_abi.cma")
    (* let () = print_endline (Zip.read_entry zip entry)*) (* This is working? Shocking *)
    (* let ()= Zip.copy_entry_to_channel zip entry stdout  *)     (* Wait, this works. *)
    let oc = (open_out_bin "./tmp.cma")
     let ()= Zip.copy_entry_to_channel zip entry  oc (* so this works. WHat *) 
     let () = close_out oc

let my_copy_entry_to_file ifile e outfilename =
  let oc = open_out_bin outfilename in
  try
    Zip.copy_entry_to_channel ifile e oc;
    print_endline "here";
    close_out oc;
    print_endline "here";
    begin try
      print_endline "here";
      Unix.utimes outfilename e.mtime e.mtime;
      print_endline "here";
    with Unix.Unix_error(_, _, _) | Invalid_argument _ -> ()
    end
  with x ->
    print_endline "Crashed";
    close_out oc;
    Sys.remove outfilename;
    raise x
    (* let () = Zip.copy_entry_to_file zip entry "./tmp.cma" *)
    let () = my_copy_entry_to_file zip entry "./tmp.cma" 
    (* This leads me to belive open_out_bin is not working? *)
    (*
            let path = Uri.path uri in
        let entry = Zip.find_entry zip path in
        let name = Option.value name ~default:path in
        Zip.copy_entry_to_file zip entry name;
        *)