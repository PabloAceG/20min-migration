" Could also use
" autocmd FileType python setlocal shiftwidth=2 softtabstop=2 expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix

let g:ycm_python_interpreter_path = '' 
let g:ycm_python_sys_path = [] 
let g:ycm_extra_conf_vim_data = [         
  \  'g:ycm_python_interpreter_path', 
  \  'g:ycm_python_sys_path'
  \] 
let g:ycm_global_ycm_extra_conf = '~/.ycm_global_extra_conf.py'
