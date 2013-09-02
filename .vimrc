execute pathogen#infect()
syntax on
filetype plugin indent on

highlight ExtraWhitespace ctermbg=red guibg=red
call matchadd('ExtraWhitespace', '\t', 10)
call matchadd('ExtraWhitespace', '\s\+\%#\@<!$', 11)

highlight TooLongLine ctermbg=lightgrey guibg=lightgrey
call matchadd('TooLongLine', '\%>80v.\+')

"Learn to use the gd hjkl
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
