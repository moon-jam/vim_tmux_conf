" Automatic install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'hotoo/pangu.vim'
Plug 'dense-analysis/ale'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'ap/vim-css-color'
Plug 'vimwiki/vimwiki'
Plug 'alvan/vim-closetag'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'lervag/vimtex'
Plug 'honza/vim-snippets'

call plug#end()

if empty(glob('~/.config/coc/extensions/package.json'))
  autocmd VimEnter * CocInstall -sync coc-clangd coc-snippets coc-tsserver coc-json coc-python coc-emmet
endif


colorscheme default
let mapleader=' '
set nocompatible
set ai                  " Auto indent
set background=dark
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab           " Replace tab with space
set smartindent
set cursorline
set clipboard^=unnamed,unnamedplus
set ic                  " Ignore case
set hlsearch            " Highlight search
set showcmd
set incsearch
set splitbelow
set splitright
set lazyredraw
set ttyfast

command! MakeTags !ctags -R .
command! -nargs=1 Hr horizontal resize <args>
command! -nargs=1 Vr vertical resize <args>

map <F4> : set nu! relativenumber!<CR>
noremap <leader>h :nohl<CR>
noremap <leader>e :NERDTreeToggle<CR>
noremap <leader>s :set spell!<CR>
noremap <leader>m <Plug>MarkdownPreviewToggle
autocmd FileType tex nnoremap <buffer> <leader>c :VimtexTocToggle<CR>

" Finding
set path+=**            " Search down into subfolder and provide tab-completion
set wildmenu            " Display all matching files when we tab complete
set wildignorecase

" Format
function! FormatOnSave()
  let l:formatted = system('clang-format', join(getline(1, '$'), "\n"))
  if v:shell_error == 0
    call setline(1, split(l:formatted, "\n"))
  endif
endfunction
autocmd BufWritePre *.h,*.hpp,*.c,*.cc,*.cpp call FormatOnSave()

" Autocomplete
hi Pmenu ctermfg=0 ctermbg=7
hi PmenuSel ctermfg=7 ctermbg=4
let g:neocomplcache_enable_smart_case = 1

" Git commit auto wrap
autocmd FileType gitcommit setlocal textwidth=72 spell

" Comment setting
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultNesting = 1

" JavaScript, HTML, JSON indent
autocmd FileType javascript,html,css,json setlocal tabstop=2 shiftwidth=2

" Close tag setting
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx'
let g:closetag_regions = {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ 'typescriptreact': 'jsxRegion,tsxRegion',
  \ 'javascriptreact': 'jsxRegion'
  \}
let g:closetag_shortcut = '>>'

" Coc Config
set updatetime=300
inoremap <silent><expr> <C-J> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

"auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()

" Pangu
autocmd BufWritePre *.markdown,*.md,*.text,*.txt,*.wiki,*.cnx call PanGuSpacing('ALL')

"Emmet
let g:user_emmet_leader_key='<C-M>'
let g:user_emmet_expandabbr_key='<C-K>'
