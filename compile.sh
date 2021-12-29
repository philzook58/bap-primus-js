ocamlfind ocamlc -g -package bap,bap-primus -package core_kernel -linkpkg primus_lisp_semantic_primitives.mli primus_lisp_semantic_primitives.ml 
ocamlfind ocamlc -g -package bap,bap-primus -package core_kernel -linkpkg primus_lisp_semantic_primitives.cmo baptest.ml 
# -linkall removed. I don't need it unless dynlinking in stuff?
# can remove --pretty and --debuginfo below if you like.
# can add --opt=2 or 3
# -I . is necessary to find the --file
js_of_ocaml --pretty --debuginfo +zarith_stubs_js/runtime.js +zarith_stubs_js/biginteger.js \
  +base/base_internalhash_types/runtime.js +base/runtime.js +time_now/runtime.js +bin_prot/runtime.js \
  +ppx_expect/collector/runtime.js +base_bigstring/runtime.js +core_kernel/strftime.js +core_kernel/runtime.js \
  +bigstringaf/runtime.js  -I . --file=core.lisp --file=init.lisp --file=memory.lisp \
  --file=pointers.lisp --file=mytest.lisp --extern-fs  a.out
#js_of_ocaml --debuginfo --pretty +core_kernel/strftime.js +base_bigstring/runtime.js +core_kernel/runtime.js \
#    +bigstringaf/runtime.js  -I . --file=core.lisp --file=init.lisp --file=memory.lisp \
#  --file=pointers.lisp --file=mytest.lisp --extern-fs  a.out