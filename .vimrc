" This is the personal vim runtime configuration of mackie mathew. 
" It should be useful for lots of people wanting a minimal configuration

" General {
    set nocompatible " make vim behave like vim not vi
    syntax on " enable syntax highlighting 
    filetype indent plugin on " Attempt to determine the type of a file 
    set autochdir " change dir automatically to working file's dir

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
    
" }

" CTags {

    set tags=tags;/ " look up ctags until one is found
    
" } 


" Search {
    set hlsearch " highlight searches, unless we press <C-L>
    set ignorecase " ignore case when searching
    set incsearch " Find as you type search
    set smartcase " except when upper case is used
    nnoremap <C-L> :nohl<CR><C-L> " turn off highlighting until the next search
" }"

" Formatting {
    set autoindent
    set backspace=eol,indent,start " Allow backspacing over autoindent, 
    "line breaks and start of insert action

    " wrap lines visually without inserting line breaks
    set wrap
    set linebreak
    set nolist  " list disables linebreak

    " prevent vim entering line breaks automatically for pasted text
    set textwidth=0
    set wrapmargin=0

    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=8                " Use indents of 4 spaces
    "set noexpandtab                   " Tabs are spaces, not tabs
    set tabstop=8                   " An indentation every four columns
    set softtabstop=8               " Let backspace delete indent
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

" }

" Status line {
    set ruler " show line number/cursor position in status line
    set laststatus=2 " always display the status line
" }

" GUI & Color schemes {
    set background=light
    colorscheme solarized
    let g:solarized_termtrans=0
    let g:solarized_contrast="high"
    let g:solarized_visibility="high"

    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if has("gui_gtk2")
            set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif has("gui_mac")
            set guifont=Monaco:h12,Andale\ Mono\ Regular:h12,Menlo\ Regular:h12,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif has("gui_win32")
            set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
        if has('gui_macvim')
            set guifont=Monaco:h12,Andale\ Mono\ Regular:h13,Menlo\ Regular:h13,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            "set transparency=5      " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif
" }

" Command Line {
    set wildmode=longest,list " Bash like path completion
    set wildmenu " Better command-line completion
    set showcmd " Show partial commands in the last line of the screen
" }

" Pathogen {
    call pathogen#infect()
" }

" Syntastic {
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" }

" Buffers {
    " Vim with default settings does not allow easy switching between multiple files
    " in the same editor window. Users can use multiple split windows or multiple
    " tab pages to edit multiple files, but it is still best to enable an option to
    " allow easier switching between files.
    "
    " One such option is the 'hidden' option, which allows you to re-use the same
    " window and switch from an unsaved buffer without saving it first. Also allows
    " you to keep an undo history for multiple files when re-using the same window
    " in this way. Note that using persistent undo also lets you undo in multiple
    " files even in the same window, but is less efficient and is actually designed
    " for keeping undo history after closing Vim entirely. Vim will complain if you
    " try to quit without saving, and swap files will keep you safe if your computer
    " crashes.
    set hidden

    " Note that not everyone likes working this way (with the hidden option).
    " Alternatives include using tabs or split windows instead of re-using the same
    " window as mentioned above, and/or either of the following options:
    " set confirm
    " set autowriteall
" }"

" Functions {
"
    " Strip whitespace {
    function! StripTrailingWhitespace()
        " To disable the stripping of whitespace, add the following to your
        " .vimrc.local file:
        "   let g:spf13_keep_trailing_whitespace = 1
        if !exists('g:spf13_keep_trailing_whitespace')
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endif
    endfunction
    " }
" }

" Tag List {
    let Tlist_GainFocus_On_ToggleOpen = 1
" {

" Key Re-mappings {

    let mapleader = ','

    " easier movement in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    map <S-H> gT
    map <S-L> gt

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Nerd Tree open
    map <C-e> :NERDTreeToggle<CR>

    " Basic C compile
    map <D-S-F11> :w<CR>:make %:r<CR><CR>

    " build tags of your own project with Ctrl-F12
    map <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
    
    " show tag list
    nnoremap <silent> <F8> :TlistUpdate<CR> :TlistToggle<CR>

    " append close bracket automatically
    inoremap {      {}<Left>
    inoremap {<CR>  {<CR>}<Esc>O
    inoremap {{     {
    inoremap {}     {}
    
    "map vsp to right
    cnoremap vsp	rightbelow vsp 
    cnoremap sp		leftabove sp 
" }
