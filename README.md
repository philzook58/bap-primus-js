So I ripped apart the primus lisp plugin to just use the bits
Specifically I'm currently targetting the primus-lisp plugin and only the semantics part of it.
This is the stuff that 
It's mainly in plugins/primus_lisp/lisp_main
primitive_semantics
and show are also of interest.

It's odd how you request the semantics of a piece of lisp

I may need to change how 

Previous gist https://gist.github.com/philzook58/6501f86082954f795812b50181d014bf

Surprisingly I needed to include core.lisp? and the others. Huh
`--file=core.lisp` seems to be working for js_of_ocaml. Thats neat.

philip@philip-XPS-13-7390-2-in-1:~/Documents/ocaml/bapjs2$ bap show-lisp foo --primus-lisp-load=mytest
foo:
((bap:ir-graph )
 (bap:insn-dests (()))
 (bap:bil ())
 (core:value ((core:val ((+ x 0x4))) (bap:exp "x +
                                               4"))))

So I don't have bil, etc. 
But I wonder if this is enough to get custom core theory intepretations working.

Stack overflow: add this to the top of the javascript file to get full stack trace

`Error.stackTraceLimit = Infinity;`


Stack size 1130 worlks

No ocamlc optimizations/options?

With bap 2.3.0 stack-size of 200 works.
https://github.com/BinaryAnalysisPlatform/bap/pull/1361

I could put .lisp files into the jsoo filesystem
Don't use any plugins. I may be able to get a primus.lisp thing
Possibly precompile and just statically link in the plugin cmo I need? Without calling init, or calling init with empty args

But what actually populates semantics?
Copy and paste the appropriate promises.

What if I could stub out Dynlink and just statically link in the plugins I want.

On bap 2.3.0 I don't run into stack overflow errors. Hypothesis: The change to th KB monad going to CPS style is really hurting without tail call elimination. https://github.com/BinaryAnalysisPlatform/bap/pull/1361

I tried using closure compiler and babel with tail call elimination plugin. Both actually screwed up my code.

Tried different optimizations and flags for jsoo. diable inline did nothing

Not clear the closure compiler even makes for smaller a.js that just turning off pretty.


Options:
- Use bap 2.3.0
- Use modified 2.4.0 that either trampolines the KB monad or returns to the 2.3.0 formulation of the monad

 when stack size is too small, you can get it to still work with
`/bin/bash -c "ulimit -s 65500; exec node --stack-size=65500 a.js"`

/home/philip/.opam/4.12.1/lib/bap-plugin-primus_lisp/primus_lisp_library_plugin.cma:


https://github.com/jscoq/jscoq/blob/722dde0ea2afedea92c5e6f0bd9de3777a768012/etc/patches/trampoline.patch Here appears to be a patch to coq to add trampolning to a cps monad
https://github.com/jscoq/jscoq/blob/b8642a43fe05070a800ec3c6694c3499d5ba26a1/Makefile They git pull and apply patche
If I'm patching bap, maybe patching out the Dynlink isn't so bad.
What if I statically linked to plugins? Ask Ivan how bad this would be ,or just try it.

https://github.com/ocsigen/js_of_ocaml/issues/620 maybe I misunderstood what works and what doesn't
Topdirs.load_file might be what I want.


https://github.com/ocsigen/js_of_ocaml/issues/620  How to use Topdirs.dir_load/Dynlink.loadfile with js files

ocamlfind ocamlc -g -package bap,compiler-libs,bap-main,compiler-libs.common,bap-plugins,compiler-libs.toplevel,js_of_ocaml,js_of_ocaml-toplevel -package core_kernel -linkall -linkpkg mybaptop.ml 

js_of_ocaml --pretty --debuginfo +zarith_stubs_js/runtime.js +zarith_stubs_js/biginteger.js   +base/base_internalhash_types/runtime.js +base/runtime.js +time_now/runtime.js +bin_prot/runtime.js   +ppx_expect/collector/runtime.js +base_bigstring/runtime.js +core_kernel/strftime.js +core_kernel/runtime.js   +bigstringaf/runtime.js --toplevel +toplevel.js --dynlink +dynlink.js  a.out

Hmm. You know, I think ivan's suggestion that the issue was dynlink was erroneous. Maybe I would've hit that, but I think it might be making it into Ocamlzip

--source-map-inline might be another good tip

dune dev builds seperately
dune release builds all as one