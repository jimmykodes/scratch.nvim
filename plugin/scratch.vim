if exists('g:loaded_scratch')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" command! -range Foo lua require('scratch').foo()
" command! Bar lua require('scratch').bar()

let g:loaded_template = 1
