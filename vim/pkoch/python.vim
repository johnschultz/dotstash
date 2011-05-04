autocmd BufRead,BufNewFile *.py syntax on
autocmd BufRead,BufNewFile *.py set ai
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,with,try,except,finally,def,class
autocmd FileType python setl autoindent tabstop=4 expandtab shiftwidth=4 softtabstop=4
autocmd FileType python set omnifunc=pythoncomplete#Complete