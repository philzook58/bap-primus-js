Trace
    at caml_ml_flush (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:4571:34)
    at close_out (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:94659:28)
    at copy_entry_to_file (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:487694:33)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:489992:44
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9690:28)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:489967:63
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9690:28)
    at protectx (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116103:17)
    at protect$0 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116114:44)
    at input$5 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:489966:38)
Uncaught exception:
  
  (Failure "Cannot flush a closed channel")

  copy_entry_to_file is a ocamlzip function
  https://github.com/BinaryAnalysisPlatform/bap/blob/97fb7fa6a8a90faeae2b077d8ad59b8b882d7c32/lib/bap_bundle/bap_bundle.ml#L157 likely called from get_file

  >>> is a combinator that opernas the file
  It is in a protect combinator that closes the file.
  Could this combinator be being called early?
  Is Zip.find_entry closing the file?
  It's also in a try catch

  Maybe the open_in is failing and returning a closed channel.


  Ok. So I can successfully run Bap.init
  Can I do it in a website and not on node?
  I immediarely stack overflow. That's nice

loader.debug> Linking library bap_c
Trace
    at to_string_default (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:105984:40)
    at string_of_event (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:106022:14)
    at sexp_of_exn (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:113800:23)
    at to_sexps_hum (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:119474:39)
    at to_sexp_hum (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:119467:17)
    at to_string_hum$0 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:119526:30)
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at _kW7_ (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520741:79)
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at bind$3 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116920:42)
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at symbol_bind (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116361:40)
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520743:61
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at fold_left$0 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:95650:19)
    at func (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:115133:36)
    at _kW3_ (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520734:50)
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at bind$3 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116920:42)
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at symbol_bind (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116361:40)
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520764:52
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at with_argv (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520703:38)
    at load$6 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520706:38)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520869:49
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at rev_filter_map (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:118455:41)
    at filter_map$1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:118461:45)
    at load$7 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:520863:33)
    at caml_call6 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9700:16)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:522932:48
    at caml_call1 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9689:28)
    at bind$3 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:116920:42)
    at caml_call2 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:9691:28)
    at symbol_bind$30 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:522802:64)
    at init$58 (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:522845:42)
    at /home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:634284:39
    at Object.<anonymous> (/home/philip/Documents/ocaml/bapjs2/staticload/_build/default/main.bc.js:634306:3)
    at Module._compile (internal/modules/cjs/loader.js:999:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1027:10)
    at Module.load (internal/modules/cjs/loader.js:863:32)
    at Function.Module._load (internal/modules/cjs/loader.js:708:14)
    at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:60:12)
    at internal/main/run_main_module.js:17:47
loader.error> Failed to load plugin "primus-taint": Failed to load bap_c: ("Stack overflow")
Failed to load plugin "primus-taint": Failed to load bap_c: ("Stack overflow")
Uncaught exception:

Hmm it seems to be failing inside a string printing inside of Plugin.do_load
But it is significantly inlined.
Maybe disabling inline might help?

ooh. This is the catch of the stack overflow.
Nevermind. I'm looking at the wrong stuff
I found "stack overflow" error
and then searched for the nonseinical symbol it was assigned to.

shit so this is going to be hard to search for.
Really I might need to recomple bap. Or can I have it fail harder?

WHat did I do?


Well, I could split out lisp semantics from lisp taint

Error.stackTraceLimit = Infinity;
Search for RangeError
Add in console.log(e.stack)

     {if(e instanceof Array)return e;
      if
       (joo_global_object.RangeError
        &&
        e instanceof joo_global_object.RangeError
        &&
        e.message
        &&
        e.message.match(/maximum call stack/i)) {
        //console.trace()
        console.log(e.stack);

Yea I'm confused about the features semantics
requiring primus-lisp requires primus-taint, but semantics requires primus-lisp and bil, but doesn't transitively require taint?

strace -e trace=open,openat,close,connect,accept dune exec ./main.bc
Ah yes
I need to include many primus lisp files in
/home/philip/.opam/bapjs/share/bap/primus