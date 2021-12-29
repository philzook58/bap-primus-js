ocamlfind ocamlc -g -package bap,bap-primus -package core_kernel -linkpkg  primus_lisp_semantic_primitives.cmo baptest.ml 
js_of_ocaml  +zarith_stubs_js/runtime.js +zarith_stubs_js/biginteger.js \
  +base/base_internalhash_types/runtime.js +base/runtime.js +time_now/runtime.js +bin_prot/runtime.js \
  +ppx_expect/collector/runtime.js +base_bigstring/runtime.js +core_kernel/strftime.js +core_kernel/runtime.js \
  +bigstringaf/runtime.js  --opt=2 -I . --file=core.lisp --file=init.lisp --file=memory.lisp \
  --file=pointers.lisp --file=mytest.lisp --extern-fs  a.out
#  /bin/bash -c "ulimit -s 65500; exec node --stack-size=65500 a.js"
#js_of_ocaml --debuginfo --pretty +core_kernel/strftime.js +base_bigstring/runtime.js +core_kernel/runtime.js \
#    +bigstringaf/runtime.js  -I . --file=core.lisp --file=init.lisp --file=memory.lisp \
#  --file=pointers.lisp --file=mytest.lisp --extern-fs  a.out