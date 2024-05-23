if exists('g:loaded_scratch')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" command! -range Foo lua require('scratch').foo()
command! -nargs=* ScratchNew lua require('scratch').create(<f-args>)
command! -nargs=* ScratchOpen lua require('scratch').open(<f-args>)

let g:loaded_template = 1
