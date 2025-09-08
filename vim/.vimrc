" =============================================================================
" Modular & Function-Based Vim Configuration
" Plugins declared at top, grouped by category
" =============================================================================

" =============================================================================
" Global Toggle Switches
" =============================================================================

" Core features
let g:enable_base = 1
let g:enable_ui = 1
let g:enable_backup = 1

" Plugin management
let g:enable_plugins = 1
let g:enable_plugin_ui = 1
let g:enable_plugin_lsp = 1
let g:enable_plugin_format = 1
let g:enable_plugin_search = 1
let g:enable_plugin_lang = 1
let g:enable_plugin_wilder = 1
let g:enable_plugin_wilder_fancy = 1

" Language-specific settings
let g:enable_lang_cpp = 1
let g:enable_lang_python = 1
let g:enable_lang_go = 1
let g:enable_lang_lua = 1
let g:enable_lang_perl = 1

" =============================================================================
" Plug check and Install
" =============================================================================

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =============================================================================
" Plugin Declarations (Top-Level, Grouped by Category)
" =============================================================================

call plug#begin()

" UI and Appearance
" Plug 'morhetz/gruvbox'
" Plug 'rafi/awesome-vim-colorschemes'
Plug 'wfxr/minimap.vim'
Plug 'voldikss/vim-floaterm'
Plug 'skywind3000/vim-quickui'
Plug 'yggdroot/indentline'
Plug 'ahonn/vim-fileheader'
Plug 'gelguy/wilder.nvim'

" Plugin Management and UI Enhancements
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }

" LSP and Language Support
Plug 'davidhalter/jedi-vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'dpelle/vim-languagetool'

" Code Formatting and Utilities
Plug 'chiel92/vim-autoformat'

" Navigation and Search
Plug 'preservim/tagbar'
Plug 'wesleyche/srcexpl'

" Language-Specific Plugins
Plug 'junegunn/vim-easy-align'
Plug 'kien/rainbow_parentheses.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'fatih/vim-go'
Plug 'tbastos/vim-lua'
Plug 'google/vim-searchindex'
Plug 'ambv/black'
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
" Plug 'sumitpo/hurl.vim'

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
Plug 'ravishi/vim-gnu-c'
Plug 'vim-scripts/nginx.vim'

" Performance profile
Plug 'tweekmonster/startuptime.vim'

call plug#end()

" =============================================================================
" 1. Core Settings
" =============================================================================

function! s:setup_base()
  if !g:enable_base | return | endif
  set nocompatible
  set showmode ruler
  set hidden
  set history=10000
  set title
  set scrolloff=4
  set hlsearch
  set incsearch
  set smartcase
  set splitbelow
  set showmatch
  set showcmd
  set autoread
  set confirm
  set ttyfast
  set backspace=indent,eol,start
  set clipboard=unnamedplus,unnamed,autoselect
  set shortmess=aoOTI
  set formatoptions=tcqro2
  set complete=.,w,b,u,t
  set completeopt=longest,menuone,preview
  set wildmenu
  set wildmode=list:longest,full
  set foldmethod=marker
  set foldlevelstart=0
  set ignorecase
  set smartindent
  set laststatus=2
  set showtabline=1
  set cursorline
  set number

  " Indentation
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
  set expandtab
  set cinoptions=(0,m1,:1
endfunction

" =============================================================================
" 2. Whitespace and Trailing Space Highlighting
" =============================================================================

function! s:setup_whitespace()
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=cyan guibg=cyan
  autocmd InsertLeave * redraw!
  match ExtraWhitespace /\s\+$\| \+\ze\t/
endfunction

" =============================================================================
" 3. Persistence: Undo, Backup, Swap
" =============================================================================

function! s:setup_persistence()
  if !g:enable_backup | return | endif

  set undofile
  set backup
  set swapfile

  set undodir=~/.vim/tmp/undo//
  set backupdir=~/.vim/tmp/backup//
  set directory=~/.vim/tmp/swap//

  for dir in [&undodir, &backupdir, &directory]
    let d = substitute(dir, '[/,]\\+$', '', '')
    if !isdirectory(d)
      call mkdir(d, 'p', 0700)
    endif
  endfor
endfunction

" =============================================================================
" 4. File Type and Syntax Setup
" =============================================================================

function! s:setup_filetype()
  filetype plugin indent on
  syntax on

  " Add LilyPond syntax support
  set runtimepath+=/opt/homebrew/Cellar/lilypond/2.24.4/share/lilypond/2.24.4/vim/
endfunction

" =============================================================================
" 5. UI and Appearance
" =============================================================================

function! s:setup_ui()
  if !g:enable_ui | return | endif

  " colorscheme gruvbox
  colorscheme retrobox

  hi Normal ctermbg=NONE guibg=NONE
  hi LineNr ctermbg=NONE guibg=NONE
  hi SignColumn ctermbg=NONE guibg=NONE
  hi CursorLine cterm=underline term=underline ctermfg=NONE ctermbg=NONE guibg=NONE

  " Session shortcuts
  noremap <F1> :mksession! .vim.session<CR>
  noremap <F2> :source .vim.session<CR>
  noremap <F3> :silent! !rm .vim.session<CR>

  " Remove trailing whitespace
  nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

  " Window navigation
  nnoremap <C-N> <C-W>w
  inoremap <C-N> <C-O><C-W>w

  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Auto-save on focus loss
  au FocusGained,BufEnter * :silent! !
  au FocusLost,WinLeave * :silent! w
endfunction

" =============================================================================
" 6. Plugin Configuration (Lazy Loaded)
" =============================================================================

function! s:setup_tagbar()
  let g:tagbar_iconchars = ['+', '-']
  let g:tagbar_autoclose = 1
  nnoremap <F9> :TagbarToggle<CR>

  let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : ['p:package','i:imports:1','c:constants','v:variables',
    \               't:types','n:interfaces','w:fields','e:embedded',
    \               'm:methods','r:constructor','f:functions'],
    \ 'sro' : '.', 'kind2scope' : {'t' : 'ctype', 'n' : 'ntype'},
    \ 'scope2kind' : {'ctype' : 't', 'ntype' : 'n'},
    \ 'ctagsbin'  : 'gotags', 'ctagsargs' : '-sort -silent'
  \ }
endfunction

function! s:setup_rainbow()
  let g:rainbow_active = 1
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces
endfunction

function! s:setup_indentline()
  let g:indentLine_char = '|'
endfunction

function! s:setup_fileheader()
  let g:header_auto_add_header = 1
  let g:header_field_author = 'guochuliang'
  let g:header_field_author_email = '2797366715@qq.com'
endfunction

function! s:setup_wilder()
  if !g:enable_plugin_wilder | return | endif

  call wilder#setup({'modes': [':', '/', '?']})
  call wilder#setup({
        \ 'modes': [':', '/', '?'],
        \ 'next_key': '<Tab>',
        \ 'previous_key': '<S-Tab>',
        \ 'accept_key': '<Down>',
        \ 'reject_key': '<Up>',
        \ })
  call wilder#set_option('renderer', wilder#popupmenu_renderer({
        \ 'highlighter': wilder#basic_highlighter(),
        \ }))

  if !g:enable_plugin_wilder_fancy | return | endif
  call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'highlights': {
      \   'border': 'Normal',
      \ },
      \ 'border': 'rounded',
      \ })))
endfunction

function! s:setup_floaterm()
  cnoreabbrev scope FloatermToggle
endfunction

" =============================================================================
" 7. Language-Specific Settings
" =============================================================================

function! s:setup_cpp()
  if !g:enable_lang_cpp | return | endif
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_posix_standard = 1
  let g:cpp_experimental_template_highlight = 1
endfunction

function! s:setup_python()
  if !g:enable_lang_python | return | endif
  let g:ycm_filetype_blacklist.python = 1
endfunction

function! s:setup_go()
  if !g:enable_lang_go | return | endif
  let g:go_fmt_command = "golines"
  let g:go_fmt_options = { 'golines': '-m 80' }
endfunction

function! s:setup_lua()
  if !g:enable_lang_lua | return | endif
endfunction

function! s:setup_perl()
  if !g:enable_lang_perl | return | endif
endfunction

function! s:setup_hurl()
  if !g:enable_lang_hurl | return | endif
endfunction

" =============================================================================
" 8. Lazy Loading by File Type
" =============================================================================

function! s:lazy_load(filetype, setup_func)
  augroup LazyLoad
    autocmd!
    autocmd FileType a:filetype call call(a:setup_func, [])
  augroup END
endfunction

call s:lazy_load('c,cpp', 's:setup_cpp')
call s:lazy_load('python', 's:setup_python')
call s:lazy_load('go', 's:setup_go')
call s:lazy_load('lua', 's:setup_lua')
call s:lazy_load('perl', 's:setup_perl')

autocmd FileType c,cpp,python,go call s:setup_tagbar()
autocmd FileType * call s:setup_rainbow()
autocmd FileType * call s:setup_indentline()
autocmd FileType * call s:setup_fileheader()

" =============================================================================
" 9. LSP Setup
" =============================================================================

function! s:setup_lsp()
  if !g:enable_plugin_lsp | return | endif
  if executable('clangd')
    augroup lsp_clangd
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': {server_info->['clangd']},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
            \ })
      autocmd FileType c,cpp setlocal omnifunc=lsp#complete
    augroup end
  endif
  if executable('ccls')
    augroup lsp_ccls
      autocmd!
      autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'ccls',
            \ 'cmd': {server_info->['ccls']},
            \ 'root_uri': {server_info->lsp#utils#path_to_uri(
            \   lsp#utils#find_nearest_parent_file_directory(
            \     lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json',
            \                               '.git/']))},
            \ 'initialization_options': { 'highlight': { 'lsRanges' : v:true } },
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
            \ })
    augroup end
  endif
endfunction

" =============================================================================
" 10. Final Initialization
" =============================================================================

call s:setup_base()
call s:setup_persistence()
call s:setup_filetype()
call s:setup_ui()
call s:setup_wilder()
" call s:setup_plugins()
autocmd VimEnter * call s:setup_lsp()

if exists('g:ycm_filetype_blacklist')
  let g:ycm_filetype_blacklist = {
    \ 'tagbar': 1, 'notes': 1, 'markdown': 1, 'netrw': 1,
    \ 'unite': 1, 'text': 1, 'vimwiki': 1, 'pandoc': 1,
    \ 'infolog': 1, 'leaderf': 1, 'mail': 1
  \}
endif

set tags=./tags,tags;
set path+=./include

autocmd VimEnter * echo "Vim configuration loaded."
