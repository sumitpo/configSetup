" File              : .vimrc
" Author            : guochuliang <2797366715@qq.com>
" Date              : 01.10.2023
" Last Modified Date: 07.02.2024
" Last Modified By  : guochuliang <2797366715@qq.com>
" use python3
if exists('py2') && has('python')
elseif has('python3')
endif

" Vundle -----------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

filetype indent on
filetype plugin on

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" On-demand loading
" Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'prabirshrestha/async.vim'
" Plug 'ajh17/vimcompletesme'
Plug 'ianding1/leetcode.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'yggdroot/indentline'
Plug 'vim-scripts/ifdef.vim'
Plug 'vim-scripts/nginx.vim'

Plug 'preservim/tagbar'

Plug 'ekalinin/dockerfile.vim'
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }

Plug 'daveyarwood/vim-alda'
Plug 'fatih/vim-go'

Plug 'jasonshell/vim-svg-indent'
Plug 'gauteh/vim-cppman'

Plug 'google/vim-searchindex'

Plug 'ycm-core/YouCompleteMe'
Plug 'dpelle/vim-languagetool'

Plug 'wesleyche/srcexpl'
Plug 'rootkiter/vim-hexedit'

Plug 'ahonn/vim-fileheader'

Plug 'voldikss/vim-floaterm'
Plug 'skywind3000/vim-quickui'

Plug 'skanehira/k8s.vim'
" Plug 'davidhalter/jedi-vim'
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

Plug 'gelguy/wilder.nvim'
"Plug 'wincent/command-t'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }

" Plug 'wesleyche/trinity'
" Plug 'tribela/vim-transparent'

" Plug 'alpertuna/vim-header'
" Plug 'gcl/funciew'

" ============for git==============
" Plug 'tpope/vim-fugitive'

" ============for format===========
Plug 'chiel92/vim-autoformat'

" ============for view =============
Plug 'rafi/awesome-vim-colorschemes'
Plug 'mnishz/colorscheme-preview.vim'
Plug 'mg979/vim-visual-multi'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }

" ============for languages=========
Plug 'wilsaj/chuck.vim'
Plug 'thecodesmith/vim-groovy'
Plug 'tfnico/vim-gradle'
Plug 'vhdirk/vim-cmake'
Plug 'pboettch/vim-cmake-syntax'
Plug 'euclidianace/betterlua.vim'
Plug 'kelwin/vim-smali'
Plug 'tbastos/vim-lua'
Plug 'mattn/perl-completion.vim'
Plug 'aklt/plantuml-syntax'
Plug 'drmikehenry/vim-headerguard'


" Games

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

" Plug 'aperezdc/vim-template'

Plug 'ravishi/vim-gnu-c'

" view
"
Plug 'wfxr/minimap.vim'

" for particular languages
" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" file type and syntax highliting on
filetype plugin indent on
syntax on

" whitespaces
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=cyan guibg=cyan
autocmd InsertLeave * redraw!
match ExtraWhitespace /\s\+$\| \+\ze\t/

" automatically remove all trailing whitespace
" autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

color gruvbox
" color molokai
" color desert
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi CursorLine cterm=underline term=underline ctermbg=NONE guibg=NONE

" sessions
noremap <F1> :mksession! .vim.session <cr>
noremap <F2> :source .vim.session <cr>
noremap <F3> :! rm .vim.session <cr>

" for autoread to auto load
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

" specific settings
set fo+=t
set t_Co=256
set title
set bs=2
set noautoindent
set ruler
set shortmess=aoOTI
set shortmess-=S
set nocompatible
set showmode
set splitbelow
set nomodeline
set showcmd
set showmatch
set tabstop=2
set shiftwidth=2
set expandtab
set cinoptions=(0,m1,:1
" set tw=80
set formatoptions=tcqro2
set smartindent
set laststatus=2
set softtabstop=2
set showtabline=1
" set sidescroll=5
set scrolloff=4
set hlsearch
set incsearch
set cursorline
set ignorecase
set smartcase
set foldmethod=marker
set ttyfast
set history=10000
set hidden
" set colorcolumn=81
set number
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview
set noswapfile
set foldlevelstart=0
set wildmenu
set wildmode=list:longest,full
" set nowrap
set exrc
set secure
set clipboard=unnamedplus,unnamed,autoselect
hi User1 guifg=#eea040 guibg=#222222
hi User2 guifg=#dd3333 guibg=#222222
hi User3 guifg=#ff66ff guibg=#222222
hi User4 guifg=#a0ee40 guibg=#222222
hi User5 guifg=#eeee40 guibg=#222222

vnoremap \y y:call system("pbcopy", getreg("\""))<CR>
nnoremap \p :call setreg("\"", system("pbpaste"))<CR>p

noremap YY "+y<CR>
noremap P "+gP<CR>
noremap XX "+x<CR>

" set statusline=
" set statusline +=%1*\ %n\ %*            "buffer number
" set statusline +=%5*%{&ff}%*            "file format
" set statusline +=%3*%y%*                "file type
" set statusline +=%4*\ %<%F%*            "full path
" set statusline +=%2*%m%*                "modified flag
" set statusline +=%1*%=%5l%*             "current line
" set statusline +=%2*/%L%*               "total lines
" set statusline +=%1*%4v\ %*             "virtual column number
" set statusline +=%2*0x%04B\ %*          "character under cursor
set autoread
set conceallevel=2
set concealcursor=vin
set confirm
set autowrite

" backup
set undofile
set undodir=~/.vim/tmp/undo//

set backup
set backupdir=~/.vim/tmp/backup//

set swapfile
set directory=~/.vim/tmp/swap//

" make directories automatically if they don't already exist
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif

" cpp-enhanced
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

" NERDTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
" let g:NERDTreeDirArrowExpandable = '>'
" let g:NERDTreeDirArrowCollapsible = 'v'

" nnoremap <F8> :NERDTreeToggle<CR>

" close brackets
" :inoremap ( ()<Esc>i
" :inoremap < <><Esc>i
" :inoremap { {}<Esc>i
" :inoremap [ []<Esc>i
" :inoremap ' ''<Esc>i
" :inoremap ` ``<Esc>i

" cursorline
" au WinLeave * set nocursorline
" au WinEnter * set cursorline
" set cursorline
"

"" Open and close all the three plugins on the same time
"nnoremap <F8>  :TrinityToggleAll<CR>
"
"" Open and close the Source Explorer separately
"nnoremap <F9>  :TrinityToggleSourceExplorer<CR>
"
"" Open and close the Taglist separately
"nnoremap <F10> :TrinityToggleTagList<CR>
"
"" Open and close the NERD Tree separately
"nnoremap <F11> :TrinityToggleNERDTree<CR>


"SrcExpl
"{{{
" // The switch of the Source Explorer
" nmap <F8> :SrcExplToggle<CR>

" // Set the height of Source Explorer window
let g:SrcExpl_winHeight = 8

" // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_refreshTime = 100

" // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_jumpKey = "<ENTER>"

" // Set "Space" key for back from the definition context
let g:SrcExpl_gobackKey = "<SPACE>"

" // In order to avoid conflicts, the Source Explorer should know what plugins except
" // itself are using buffers. And you need add their buffer names into below list
" // according to the command ":buffers!"
let g:SrcExpl_pluginList = [
      \ "__Tag_List__",
      \ "_NERD_tree_",
      \ "Source_Explorer"
      \ ]

" // The color schemes used by Source Explorer. There are five color schemes
" // supported for now - Red, Cyan, Green, Yellow and Magenta. Source Explorer
" // will pick up one of them randomly when initialization.
let g:SrcExpl_colorSchemeList = [
      \ "Red",
      \ "Cyan",
      \ "Green",
      \ "Yellow",
      \ "Magenta"
      \ ]

" // Enable/Disable the local definition searching, and note that this is not
" // guaranteed to work, the Source Explorer doesn't check the syntax for now.
" // It only searches for a match with the keyword according to command 'gd'
let g:SrcExpl_searchLocalDef = 1

" // Workaround for Vim bug @https://goo.gl/TLPK4K as any plugins using autocmd for
" // BufReadPre might have conflicts with Source Explorer. e.g. YCM, Syntastic etc.
let g:SrcExpl_nestedAutoCmd = 1

" // Do not let the Source Explorer update the tags file when opening
let g:SrcExpl_isUpdateTags = 0

" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to
" // create/update the tags file
let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."

" // Set "<F12>" key for updating the tags file artificially
let g:SrcExpl_updateTagsKey = "<F12>"

" // Set "<F3>" key for displaying the previous definition in the jump list
let g:SrcExpl_prevDefKey = "<F3>"

" // Set "<F4>" key for displaying the next definition in the jump list
let g:SrcExpl_nextDefKey = "<F4>"
"}}}

" clang stuff
" let g:clang_library_path='/usr/lib/llvm/12/lib64/'
let g:clang_library_path='/usr/lib/'
let g:clang_user_options='|| exit 0'
let g:clang_complete_auto = 0
let g:clang_compelte_macros=1
let g:clang_complete_copen = 0
let g:clang_debug = 1
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='clang_complete'
let g:clang_auto_select = 1
let g:clang_use_library = 1
let g:clang_complete_optional_args_in_snippets = 1

" indentLine
let g:indentLine_char='|'

" ale
"
let g:ale_enabled = 0

"{{{
" tagbar
let g:tagbar_iconchars = ['+', '-']
nnoremap <F9> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
" let g:tagbar_autofocus=1
""
"}}}

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'separately': {
\       'cmake': 0,
\   }
\}

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" set tags=./tags;,tags;
set tags=./tags,tags;

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" neoformat
" "
" augroup fmt
"   autocmd!
"   autocmd BufWritePre * undojoin | Neoformat
" augroup END

if executable('clangd')
  augroup lsp_clangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd']},
          \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
          \ })
    autocmd FileType c setlocal omnifunc=lsp#complete
    autocmd FileType cpp setlocal omnifunc=lsp#complete
    autocmd FileType objc setlocal omnifunc=lsp#complete
    autocmd FileType objcpp setlocal omnifunc=lsp#complete
  augroup end
endif

" setting with vim-lsp
if executable('ccls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(
        \   lsp#utils#find_nearest_parent_file_directory(
        \     lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json', '.git/']))},
        \ 'initialization_options': {
        \   'highlight': { 'lsRanges' : v:true },
        \ },
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \ })
endif

" wilder
" Key bindings can be changed, see below
call wilder#setup({'modes': [':', '/', '?']})
" default keys
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<Tab>',
      \ 'previous_key': '<S-Tab>',
      \ 'accept_key': '<Down>',
      \ 'reject_key': '<Up>',
      \ })
" 'highlighter' : applies highlighting to the candidates
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))
function! _wilderMenuSet()
  call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
        \ 'highlights': {
        \   'border': 'Normal',
        \ },
        \ 'border': 'rounded',
        \ })))
endfunction

" vim transparent
" default
let g:transparent_groups = ['Normal', 'Comment', 'Constant', 'Special', 'Identifier',
      \ 'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String',
      \ 'Function', 'Conditional', 'Repeat', 'Operator', 'Structure',
      \ 'LineNr', 'NonText', 'SignColumn', 'CursorLineNr', 'EndOfBuffer']

" Pmenu
let g:transparent_groups += ['Pmenu']

" coc.nvim
" let g:transparent_groups += ['NormalFloat', 'CocFloating']

augroup transparent
  autocmd VimEnter,ColorScheme * call MyTransparent()
augroup END

function! MyTransparent()
  " Customize the highlight groups for transparency in here.

  " CursorLine
  "hi CursorLine ctermfg=NONE ctermbg=239 guibg=NONE guibg=#4e4e4e

  " coc.nvim
  "hi CocMenuSel ctermbg=239 guibg=#4e4e4e
endfunction

" vim header
let g:header_auto_add_header = 1
let g:header_field_author = 'guochuliang'
let g:header_field_author_email = '2797366715@qq.com'

" youcompleteme configure
let g:ycm_filetype_blacklist = {
      \ 'python': 1,
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}

nnoremap <C-N>   <C-W>w
inoremap <C-N>   <C-O><C-W>w

" floatermtoggle
cnoreabbrev scope FloatermToggle

" auto format
" au BufWrite * :Autoformat

set path+=./include


" vim go
let g:go_fmt_command = "golines"
let g:go_fmt_options = {
    \ 'golines': '-m 80',
    \ }
