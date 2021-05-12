let SessionLoad = 1
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
imap <Nul> <C-Space>
inoremap <expr> <Up> pumvisible() ? "\" : "\<Up>"
inoremap <expr> <S-Tab> pumvisible() ? "\" : "\<S-Tab>"
inoremap <expr> <Down> pumvisible() ? "\" : "\<Down>"
imap <C-R>	 <Plug>MuT_cWORD
imap <C-R>  <Plug>MuT_ckword
inoremap <silent> <Plug>MuT_cWORD =lh#mut#search_templates(lh#ui#GetCurrentWord())
inoremap <silent> <Plug>MuT_ckword =lh#mut#search_templates(lh#ui#GetCurrentKeyword())
inoremap <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <silent> <M-F9> <Plug>ToggleMarkers
inoremap <silent> <Plug>ToggleMarkers :call lh#brackets#toggle_usemarks()
imap <silent> <F9> <Plug>ToggleBrackets
inoremap <silent> <Plug>ToggleBrackets :call lh#brackets#toggle()
inoremap <silent> <Plug>MarkersJumpOutside =lh#brackets#jump_outside({'mode': 'i'})
imap <silent> <Plug>MarkersCloseAllAndJumpToLast =lh#brackets#close_all_and_jump_to_last_on_line(lh#brackets#closing_chars(), {})
imap <silent> <Plug>MarkersJumpAndDelB <Plug>MarkersJumpFAndDel
imap <silent> <Plug>MarkersJumpAndDelF <Plug>MarkersJumpFAndDel
inoremap <silent> <Plug>MarkersJumpB =lh#marker#_jump({'direction':0, 'mode':'i'})
inoremap <silent> <Plug>MarkersJumpF =lh#marker#_jump({'direction':1, 'mode':'i'})
imap <silent> <Plug>MarkersMark <Plug>MarkersInsertMark=lh#marker#_move_within_marker()
inoremap <silent> <Plug>MarkersInsertMark =lh#marker#txt()
imap <silent> <C-L><End> <Plug>MarkersJumpOutside
imap <silent> <C-L>$ <Plug>MarkersCloseAllAndJumpToLast
imap <silent> <C-L><S-Del> <Plug>MarkersJumpB
imap <silent> <C-J> <Plug>MarkersJumpF
imap <silent> <C-L><Insert> <Plug>MarkersMark
vmap <silent> <NL> <Plug>MarkersJumpF
nmap <silent> <NL> <Plug>MarkersJumpF
xmap <silent> <End> <Plug>MarkersJumpOutside
smap <silent> <End> <Plug>MarkersJumpOutside
nmap <silent> <End> <Plug>MarkersJumpOutside
vmap <silent> $ <Plug>MarkersCloseAllAndJumpToLast
nmap <silent> $ <Plug>MarkersCloseAllAndJumpToLast
vmap <silent> <S-Del> <Plug>MarkersJumpB
nmap <silent> <S-Del> <Plug>MarkersJumpB
vmap <silent> <Insert> <Plug>MarkersMark
nmap <silent> <Insert> <Plug>MarkersMark
vmap 	 <Plug>MuT_Surround
xnoremap <silent> v :call lh#sir#OpenWith('nobang', 'vsp', &path, expand(lh#visual#selection()))
xnoremap <silent> f :call lh#sir#OpenWith('nobang', 'sp', &path, expand(lh#visual#selection()))
nnoremap <silent> v :call lh#sir#OpenWith('nobang', 'vsp', &path, expand('<cfile>'))
nnoremap <silent> f :call lh#sir#OpenWith('nobang', 'sp', &path, expand('<cfile>'))
xmap <silent> <M-Down> <Plug>CTagsSplitOpen
nmap <silent> <M-Down> <Plug>CTagsSplitOpen
vmap <silent> i <Plug>InsertImport
nmap <silent> i <Plug>InsertImport
nmap <silent> th <Plug>CTagsUpdateHighlight
nmap <silent> ts <Plug>CTagsUpdateSpell
nmap <silent> tc <Plug>CTagsUpdateCurrent
nmap <silent> ta <Plug>CTagsUpdateAll
nmap <silent> "" viw""
xnoremap <silent> "" @=lh#map#surround("\"", "\"", 0, 0, '`>ll', 1)
nmap <silent> '' viw''
xnoremap <silent> '' @=lh#map#surround("'", "'", 0, 0, '`>ll', 1)
nmap <silent> ( viw(
xnoremap <silent> ( @=lh#map#surround("(", ")", 0, 0, '`>ll', 1)
nmap <silent> \ctpw <Plug>TogglePreviewIfHold
nnoremap \xx :w:!${CECCMD}/flist -x  % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \xs :w:!${CECCMD}/flist -xs % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \xg :w:!${CECCMD}/flist -xg % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \ps :w:!${CECCMD}/flist -ps % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \pp :w:!${CECCMD}/flist -p  % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \pg :w:!${CECCMD}/flist -pg % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \pc :w:!${CECCMD}/flist -c  % >tmp.vim:r tmp.vim:!rm tmp.vim
nnoremap \d :YcmShowDetailedDiagnostic
nmap <silent> \{ V\{
xnoremap <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <silent> \< viw\<
xnoremap <silent> \< @=lh#map#surround("<", ">", 0, 0, '`>ll', 1)
nmap <silent> \[ viw\[
xnoremap <silent> \[ @=lh#map#surround("[", "]", 0, 0, '`>ll', 1)
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> glf :echo globpath(&path, expand('<cfile>'))
nnoremap <silent> gf :call lh#sir#OpenWith('nobang', 'e', &path, expand('<cfile>'))
xnoremap <silent> if :call lh#dev#_select_current_function()gv
onoremap <silent> if :call lh#dev#_select_current_function()
nmap <silent> { viw{
xnoremap <silent> { @=lh#map#surround("{", "}", 0, 0, '`>ll', 1)
nnoremap <SNR>171_: :=v:count ? v:count : ''
nnoremap <Plug>TogglePreviewIfHold :Toggle Cpreview_if_hold
nnoremap <Plug>C_SelectExpr4Surrounding :call lh#cpp#snippets#select_expr_4_surrounding()
vmap <C-R>	 <Plug>MuT_Surround
vnoremap <silent> <Plug>MuT_Surround :call lh#mut#surround()
vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(netrw#GX(),netrw#CheckIfRemote(netrw#GX()))
xnoremap <silent> <C-W>v :call lh#sir#OpenWith('nobang', 'vsp', &path, expand(lh#visual#selection()))
xnoremap <silent> <C-W>f :call lh#sir#OpenWith('nobang', 'sp', &path, expand(lh#visual#selection()))
nnoremap <silent> <C-W>v :call lh#sir#OpenWith('nobang', 'vsp', &path, expand('<cfile>'))
nnoremap <silent> <C-W>f :call lh#sir#OpenWith('nobang', 'sp', &path, expand('<cfile>'))
nnoremap <silent> <Plug>ToggleBackslash :call lh#brackets#_toggle_backslash()
nnoremap <silent> <Plug>ChangeToSingleQuotes :call lh#brackets#_change_to(["'", "'"])
nnoremap <silent> <Plug>ChangeToDoubleQuotes :call lh#brackets#_change_to(['"', '"'])
nnoremap <silent> <Plug>ChangeToAngleBrackets :call lh#brackets#_change_to(['<', '>'])
nnoremap <silent> <Plug>ChangeToCurlyBrackets :call lh#brackets#_change_to(['{', '}'])
nnoremap <silent> <Plug>ChangeToSquareBrackets :call lh#brackets#_change_to(['[', ']'])
nnoremap <silent> <Plug>ChangeToRoundBrackets :call lh#brackets#_change_to(['(', ')'])
nnoremap <silent> <Plug>DeleteBrackets :call lh#brackets#_delete_brackets()
nnoremap <silent> <M-b> :call lh#brackets#_manip_mode("\â")
nmap <silent> <M-F9> <Plug>ToggleMarkers
nnoremap <silent> <Plug>ToggleMarkers :call lh#brackets#toggle_usemarks()
nmap <silent> <F9> <Plug>ToggleBrackets
nnoremap <silent> <Plug>ToggleBrackets :call lh#brackets#toggle()
smap <silent> <Plug>MarkersJumpOutside a<Plug>MarkersJumpOutside
xnoremap <silent> <Plug>MarkersJumpOutside @=lh#brackets#jump_outside({'mode': 'x'})
nnoremap <silent> <Plug>MarkersJumpOutside @=lh#brackets#jump_outside({'mode': 'n'})
vnoremap <silent> <Plug>MarkersCloseAllAndJumpToLast `<i=lh#brackets#close_all_and_jump_to_last_on_line(lh#brackets#closing_chars(), {'mode': 'v'})
nnoremap <silent> <Plug>MarkersCloseAllAndJumpToLast a=lh#brackets#close_all_and_jump_to_last_on_line(lh#brackets#closing_chars(), {})
nnoremap <silent> <Plug>MarkersJumpAndDelB @=lh#marker#_jump({'direction':0, 'mode':'n', 'delete':1})
vnoremap <silent> <Plug>MarkersJumpAndDelB @=lh#marker#_jump({'direction':0, 'mode':'v', 'delete':1})
nnoremap <silent> <Plug>MarkersJumpAndDelF @=lh#marker#_jump({'direction':1, 'mode':'n', 'delete':1})
vnoremap <silent> <Plug>MarkersJumpAndDelF @=lh#marker#_jump({'direction':1, 'mode':'v', 'delete':1})
nnoremap <silent> <Plug>MarkersJumpB @=lh#marker#_jump({'direction':0, 'mode':'n'})
vnoremap <silent> <Plug>MarkersJumpB `<@=lh#marker#_jump({'direction':0, 'mode':'v'})
nnoremap <silent> <Plug>MarkersJumpF @=lh#marker#_jump({'direction':1, 'mode':'n'})
vnoremap <silent> <Plug>MarkersJumpF @=lh#marker#_jump({'direction':1, 'mode':'v'})
nmap <silent> <Plug>MarkersMark viw<Plug>MarkersMark
vnoremap <silent> <Plug>MarkersMark @=lh#marker#_toggle_marker_in_visual()
xmap <silent> <C-L><End> <Plug>MarkersJumpOutside
smap <silent> <C-L><End> <Plug>MarkersJumpOutside
nmap <silent> <C-L><End> <Plug>MarkersJumpOutside
vmap <silent> <C-L>$ <Plug>MarkersCloseAllAndJumpToLast
nmap <silent> <C-L>$ <Plug>MarkersCloseAllAndJumpToLast
vmap <silent> <C-L><S-Del> <Plug>MarkersJumpB
nmap <silent> <C-L><S-Del> <Plug>MarkersJumpB
vmap <silent> <C-J> <Plug>MarkersJumpF
nmap <silent> <C-J> <Plug>MarkersJumpF
vmap <silent> <C-L><Insert> <Plug>MarkersMark
nmap <silent> <C-L><Insert> <Plug>MarkersMark
vmap <silent> <C-X>i <Plug>InsertImport
vnoremap <silent> <Plug>InsertImport :call lh#dev#import#_insert_import(lh#visual#selection())
nmap <silent> <C-X>i <Plug>InsertImport
nnoremap <silent> <Plug>InsertImport :call lh#dev#import#_insert_import()
nmap <silent> <C-X>th <Plug>CTagsUpdateHighlight
nmap <silent> <C-X>ts <Plug>CTagsUpdateSpell
nmap <silent> <C-X>tc <Plug>CTagsUpdateCurrent
nmap <silent> <C-X>ta <Plug>CTagsUpdateAll
nnoremap <silent> <Plug>CTagsUpdateHighlight :call lh#tags#update_highlight()
nnoremap <silent> <Plug>CTagsUpdateSpell :call lh#tags#update_spellfile()
nnoremap <silent> <Plug>CTagsUpdateAll :call lh#tags#update_all()
nnoremap <silent> <Plug>CTagsUpdateCurrent :call lh#tags#update_current()
xmap <silent> <C-W><M-Down> <Plug>CTagsSplitOpen
xnoremap <silent> <Plug>CTagsSplitOpen :call lh#tags#split_open(lh#visual#selection())
nmap <silent> <C-W><M-Down> <Plug>CTagsSplitOpen
nnoremap <silent> <Plug>CTagsSplitOpen :call lh#tags#split_open()
inoremap <expr> 	 pumvisible() ? "\" : "\	"
imap <silent> <NL> <Plug>MarkersJumpF
imap <silent> <End> <Plug>MarkersJumpOutside
imap <silent> $ <Plug>MarkersCloseAllAndJumpToLast
imap <silent> <S-Del> <Plug>MarkersJumpB
imap <silent> <Insert> <Plug>MarkersMark
inoremap <silent> <expr>  lh#mapping#_switch('''''', [{'action': 'lh#brackets#_add_newline_between_brackets()', 'condition': 'getline(".")[col(".")-2:col(".")-1]=="{}"'}])
imap 	 <Plug>MuT_cWORD
imap   <Plug>MuT_ckword
inoremap <silent> <expr> " lh#brackets#opener("\"",0,"","\"","\"",1,'')
inoremap <silent> <expr> ' lh#brackets#opener("'",0,"","'","'",1,function('lh#ft#is_text'))
inoremap <silent> <expr> ( lh#brackets#opener("(",0,"","(",")",0,'')
inoremap <silent> <expr> ) lh#brackets#closer(")",")","")
inoremap /*1 0/*75a=a*/
nnoremap <silent> â :call lh#brackets#_manip_mode("\â")
inoremap <silent> <expr> [ lh#brackets#opener("[",0,"","[","]",0,'')
inoremap <silent> <expr> ] lh#brackets#closer("]","]","")
inoremap <silent> <expr> { lh#brackets#opener("{",0,"","{","}",0,'')
inoremap <silent> <expr> } lh#brackets#closer("}","}","")
cnoreabbr firend friend
let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set cmdheight=3
set completeopt=preview,menuone
set cpoptions=aAeFsB
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=de
set listchars=tab:|\ ,trail:#
set previewheight=4
set runtimepath=~/.vim,~/.vim/plugged/YouCompleteMe,~/.vim/plugged/syntastic,~/.vim/plugged/vim-fugitive,~/.vim/plugged/vim-cpp-enhanced-highlight,~/.vim/plugged/stakeholders_vim,~/.vim/plugged/YCM-Generator,~/.vim/plugged/editorconfig-vim,~/.vim/plugged/lh-vim-lib,~/.vim/plugged/lh-style,~/.vim/plugged/lh-tags,~/.vim/plugged/lh-dev,~/.vim/plugged/lh-brackets,~/.vim/plugged/SearchInRuntime,~/.vim/plugged/mu-template,~/.vim/plugged/alternate-lite,~/.vim/plugged/lh-cpp,~/.vim/plugged/vim-colors-solarized,~/.vim/plugged/nerdtree,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim82,/usr/local/share/vim/vim82/pack/dist/opt/termdebug,/usr/local/share/vim/vimfiles/after,~/.vim/plugged/vim-cpp-enhanced-highlight/after,~/.vim/plugged/lh-vim-lib/after,~/.vim/plugged/lh-brackets/after,~/.vim/plugged/mu-template/after,~/.vim/plugged/lh-cpp/after,~/.vim/after
set shiftwidth=4
set shortmess=filnxtToOSc
set noshowmode
set splitbelow
set splitright
set statusline=%#warningmsg#%{SyntasticStatuslineFlag()}%*
set tabstop=4
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/projects/dsp/DtBlkFx/src
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
$argadd .
set stal=2
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabrewind
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
enew
file NERD_tree_1
let s:cpo_save=&cpo
set cpo&vim
nnoremap <buffer> <silent> <NL> :call nerdtree#ui_glue#invokeKeyMap("<C-j>")
nnoremap <buffer> <silent>  :call nerdtree#ui_glue#invokeKeyMap("<C-k>")
nnoremap <buffer> <silent>  :call nerdtree#ui_glue#invokeKeyMap("<CR>")
nnoremap <buffer> <silent> ? :call nerdtree#ui_glue#invokeKeyMap("?")
nnoremap <buffer> <silent> A :call nerdtree#ui_glue#invokeKeyMap("A")
nnoremap <buffer> <silent> B :call nerdtree#ui_glue#invokeKeyMap("B")
nnoremap <buffer> <silent> C :call nerdtree#ui_glue#invokeKeyMap("C")
nnoremap <buffer> <silent> CD :call nerdtree#ui_glue#invokeKeyMap("CD")
nnoremap <buffer> <silent> D :call nerdtree#ui_glue#invokeKeyMap("D")
nnoremap <buffer> <silent> F :call nerdtree#ui_glue#invokeKeyMap("F")
nnoremap <buffer> <silent> I :call nerdtree#ui_glue#invokeKeyMap("I")
nnoremap <buffer> <silent> J :call nerdtree#ui_glue#invokeKeyMap("J")
nnoremap <buffer> <silent> K :call nerdtree#ui_glue#invokeKeyMap("K")
nnoremap <buffer> <silent> O :call nerdtree#ui_glue#invokeKeyMap("O")
nnoremap <buffer> <silent> P :call nerdtree#ui_glue#invokeKeyMap("P")
nnoremap <buffer> <silent> R :call nerdtree#ui_glue#invokeKeyMap("R")
nnoremap <buffer> <silent> T :call nerdtree#ui_glue#invokeKeyMap("T")
nnoremap <buffer> <silent> U :call nerdtree#ui_glue#invokeKeyMap("U")
nnoremap <buffer> <silent> X :call nerdtree#ui_glue#invokeKeyMap("X")
nnoremap <buffer> <silent> cd :call nerdtree#ui_glue#invokeKeyMap("cd")
nnoremap <buffer> <silent> e :call nerdtree#ui_glue#invokeKeyMap("e")
nnoremap <buffer> <silent> f :call nerdtree#ui_glue#invokeKeyMap("f")
nnoremap <buffer> <silent> go :call nerdtree#ui_glue#invokeKeyMap("go")
nnoremap <buffer> <silent> gi :call nerdtree#ui_glue#invokeKeyMap("gi")
nnoremap <buffer> <silent> gs :call nerdtree#ui_glue#invokeKeyMap("gs")
nnoremap <buffer> <silent> i :call nerdtree#ui_glue#invokeKeyMap("i")
nnoremap <buffer> <silent> m :call nerdtree#ui_glue#invokeKeyMap("m")
nnoremap <buffer> <silent> o :call nerdtree#ui_glue#invokeKeyMap("o")
nnoremap <buffer> <silent> p :call nerdtree#ui_glue#invokeKeyMap("p")
nnoremap <buffer> <silent> q :call nerdtree#ui_glue#invokeKeyMap("q")
nnoremap <buffer> <silent> r :call nerdtree#ui_glue#invokeKeyMap("r")
nnoremap <buffer> <silent> s :call nerdtree#ui_glue#invokeKeyMap("s")
nnoremap <buffer> <silent> t :call nerdtree#ui_glue#invokeKeyMap("t")
nnoremap <buffer> <silent> u :call nerdtree#ui_glue#invokeKeyMap("u")
nnoremap <buffer> <silent> x :call nerdtree#ui_glue#invokeKeyMap("x")
nnoremap <buffer> <silent> <MiddleMouse> :call nerdtree#ui_glue#invokeKeyMap("<MiddleMouse>")
nnoremap <buffer> <silent> <2-LeftMouse> :call nerdtree#ui_glue#invokeKeyMap("<2-LeftMouse>")
nnoremap <buffer> <silent> <C-K> :call nerdtree#ui_glue#invokeKeyMap("<C-k>")
nnoremap <buffer> <silent> <C-J> :call nerdtree#ui_glue#invokeKeyMap("<C-j>")
nnoremap <buffer> <silent> <LeftRelease> <LeftRelease>:call nerdtree#ui_glue#invokeKeyMap("<LeftRelease>")
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=hide
setlocal nobuflisted
setlocal buftype=nofile
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,i
setlocal concealcursor=nvic
setlocal conceallevel=2
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal cursorline
setlocal cursorlineopt=both
setlocal define=
setlocal dictionary=
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'nerdtree'
setlocal filetype=nerdtree
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal nofoldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=tcq
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal nolist
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal nomodifiable
setlocal nrformats=bin,octal,hex
set number
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal readonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=%{exists('b:NERDTree')?b:NERDTree.root.path.str():''}
setlocal suffixesadd=
setlocal noswapfile
setlocal synmaxcol=3000
if &syntax != 'nerdtree'
setlocal syntax=nerdtree
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal nowrap
setlocal wrapmargin=0
tabnext
edit DtBlkFxEditor.h
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^\\s*#\\s*define
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 29) / 58)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 02|
tabnext
edit DtBlkFxProcessor.h
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 104 + 61) / 123)
exe 'vert 2resize ' . ((&columns * 104 + 61) / 123)
argglobal
balt ../src/DtBlkFxProcessor.cpp
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 69 - ((54 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 69
normal! 0
wincmd w
argglobal
if bufexists("../src/DtBlkFxProcessor.cpp") | buffer ../src/DtBlkFxProcessor.cpp | else | edit ../src/DtBlkFxProcessor.cpp | endif
balt DtBlkFxProcessor.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 3 - ((2 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 02|
wincmd w
exe 'vert 1resize ' . ((&columns * 104 + 61) / 123)
exe 'vert 2resize ' . ((&columns * 104 + 61) / 123)
tabnext
edit ParamsDelay.h
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ParamsDelay.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 30 - ((29 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 30
normal! 0
tabnext
edit MorphParam.h
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt MorphParam.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 6 - ((5 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 6
normal! 0
tabnext
edit misc_stuff.h
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt misc_stuff.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 7 - ((6 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 7
normal! 0
tabnext
edit DtBlkFxProcessor.h
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt DtBlkFxProcessor.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sr:/*,mb:*,exl:*/,:///,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^(#s*define|[a-z]*s*const(expr)=s*[a-z]*)
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 85 - ((45 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 85
normal! 034|
tabnext
edit DtBlkFxEditor.h
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 104 + 61) / 123)
exe 'vert 2resize ' . ((&columns * 104 + 61) / 123)
argglobal
balt DtBlkFxEditor.cpp
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^\\s*#\\s*define
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 22 - ((21 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 22
normal! 011|
wincmd w
argglobal
if bufexists("DtBlkFxEditor.cpp") | buffer DtBlkFxEditor.cpp | else | edit DtBlkFxEditor.cpp | endif
balt DtBlkFxEditor.h
let s:cpo_save=&cpo
set cpo&vim
imap <buffer> <C-X>cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> <C-X>rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> <C-X>be =lh#cpp#snippets#_begin_end('begin')
inoremap <buffer> <M-t> =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> <M-n> lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> <M-b> (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> <M-s> std::
inoremap <buffer> <silent> <expr> <BS> lh#mapping#_switch('''\<bs\>''', [{'action': 'lh#cpp#brackets#move_semicolon_back_to_string_context()', 'condition': 'getline(".")[:col(".")-2]=~".*\"\\s*)\\+;$"'}, {'action': 'lh#brackets#_delete_empty_bracket_pair()', 'condition': 'lh#brackets#_match_any_bracket_pair()'}])
imap <buffer> <silent> <C-X>se <Plug>SwitchEnum
inoremap <buffer> <silent> <Plug>SwitchEnum :SwitchEnum
inoremap <buffer> <silent> <expr> <kDivide><kMultiply> lh#brackets#opener("<kDivide><kMultiply>",0,"","/*","*/",0,'')
inoremap <buffer> <M-r> =lh#cpp#snippets#insert_return()
inoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
imap <buffer> <C-X>i <Plug>CompleteIncludes
imap <buffer> <C-X>MI <Plug>MoveToImpl
imap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
imap <buffer> <C-X>PI <Plug>PasteImpl
imap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
imap <buffer> <C-X>GI <Plug>GotoImpl
inoremap <buffer> <Plug>PasteImpl :PASTEIMPL
inoremap <buffer> <Plug>GotoImpl :GOTOIMPL
nmap <buffer> i <Plug>OpenIncludes
nmap <buffer> cbe viwcbe
xmap <buffer> cbe ci,".cbegin(),".cend()
nmap <buffer> rbe viwrbe
xmap <buffer> rbe ci,".rbegin(),".rend()
nmap <buffer> be viwbe
xmap <buffer> be ci,".begin(),".end()
nmap <buffer> u viwu
nmap <buffer> ;MI <Plug>MoveToImpl
nmap <buffer> ;PI <Plug>PasteImpl
nmap <buffer> ;GI <Plug>GotoImpl
nnoremap <buffer> ;RI :REACHINLINE 
nnoremap <buffer> ;AA :ADDATTRIBUTE
nnoremap <buffer> ;GR :GROUP 
nnoremap <buffer> ;MGR :MGROUP 
nnoremap <buffer> ;BL :BLINE 
nnoremap <buffer> ;CL :CLASS 
nnoremap <buffer> ;HE :HEADER 
inoremap <buffer> ô =lh#map#insert_seq('ô', '\<c-r\>=lh#cpp#snippets#typedef_typename()\<cr\>')
inoremap <buffer> <expr> î lh#cpp#snippets#current_namespace("\î")
inoremap <buffer> <expr> â (getline('.')=~'#\s*include') ? 'boost/' : 'boost::'
inoremap <buffer> ó std::
inoremap <buffer> ò =lh#cpp#snippets#insert_return()
onoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nnoremap <buffer> <silent> [[ :call lh#dev#_goto_function_begin()
nmap <buffer> [M <Plug>PrevFunctionEnd
nmap <buffer> [m <Plug>PrevFunctionStart
nmap <buffer> <silent> \\dc viw\\dc
vnoremap <buffer> <silent> \\dc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('dc')
nmap <buffer> <silent> \\rc viw\\rc
vnoremap <buffer> <silent> \\rc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('rc')
nmap <buffer> <silent> \\cc viw\\cc
vnoremap <buffer> <silent> \\cc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('cc')
nmap <buffer> <silent> \\sc viw\\sc
vnoremap <buffer> <silent> \\sc :'<,'>call lh#cpp#snippets#_convert_to_cpp_cast('sc')
nmap <buffer> <silent> \lc viw\lc
vnoremap <buffer> <silent> \lc @=lh#style#surround('boost::lexical_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'boost::lexical_cast<')
nmap <buffer> <silent> \dc viw\dc
vnoremap <buffer> <silent> \dc @=lh#style#surround('dynamic_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'dynamic_cast<')
nmap <buffer> <silent> \rc viw\rc
vnoremap <buffer> <silent> \rc @=lh#style#surround('reinterpret_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'reinterpret_cast<')
nmap <buffer> <silent> \cc viw\cc
vnoremap <buffer> <silent> \cc @=lh#style#surround('const_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'const_cast<')
vnoremap <buffer> <silent> \sc @=lh#style#surround('static_cast<!cursorhere!>(', '!mark!)',0, 0, '', 1, 'static_cast<')
nmap <buffer> \\catch V\\catch
vnoremap <buffer> \\catch @=lh#style#surround('catch(', '!cursorhere!){!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \catch V\catch
vnoremap <buffer> \catch @=lh#style#surround('catch(!cursorhere!){', '!mark!}', 0, 1, '', 1, 'catch ')
nmap <buffer> \try V\try
vnoremap <buffer> \try @=lh#style#surround('try{!cursorhere!', '!mark!}catch(!mark!){!mark!}', 0, 1, '', 1, 'try ')
nmap <buffer> \ns V\ns
vnoremap <buffer> <silent> \ns @=lh#style#surround('namespace !cursorhere!{', '!mark!}!mark!', 0, 1, '', 1, 'namespace ')
nmap <buffer> <silent> \tt viw\tt
xnoremap <buffer> <silent> \tt @=lh#map#surround("<tt>", "</tt>", 0, 0, '`>ll', 1)
nmap <buffer> <silent> \{ V\{
xnoremap <buffer> <silent> \{ @=lh#map#surround("{!cursorhere!", "}!mark!", 1, 1, '', 1, "\{")
nmap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
nmap <buffer> <silent> \pw <Plug>PreviewWord
nmap <buffer> \switch V\switch
xnoremap <buffer> <silent> \switch @=lh#style#surround('switch(!cursorhere!){case !mark!:', '}!mark!', 1, 1, '', 1, 'switch ')
nmap <buffer> \\do <Plug>C_SelectExpr4Surrounding\\do
nmap <buffer> \do V\do
xnoremap <buffer> \\d2 @=SurroundBySubstitute('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \\do @=Surround('do{!cursorhere!}while(', ');!mark!', 0, 1, '', 1, 'do ')
xnoremap <buffer> <silent> \do @=lh#style#surround('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
nmap <buffer> \\while <Plug>C_SelectExpr4Surrounding\\wh
nmap <buffer> \while V\wh
xnoremap <buffer> <silent> \\wh @=lh#style#surround('while(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'while ')
xnoremap <buffer> <silent> \wh @=lh#style#surround('while(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'while ')
nmap <buffer> \for V\for
xnoremap <buffer> <silent> \for @=lh#style#surround('for(!cursorhere!;!mark!;!mark!){', '}!mark!', 0, 1, '', 1, 'for ')
nmap <buffer> \else V\else
xnoremap <buffer> <silent> \else @=lh#style#surround('else {', '}', 0, 1, '``l', 1, 'else ')
nmap <buffer> \elif V\elif
nmap <buffer> \\elif <Plug>C_SelectExpr4Surrounding\\elif
xnoremap <buffer> <silent> \\elif @=lh#style#surround('else if(', '!cursorhere!){!mark!}!mark!', 0, 1, '', 1, 'elif ')
xnoremap <buffer> <silent> \elif @=lh#style#surround('else if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'elif ')
nmap <buffer> \\if <Plug>C_SelectExpr4Surrounding\\if
nmap <buffer> \if V\if
xnoremap <buffer> <silent> \\if @=lh#style#surround('if(', '!cursorhere!) {!mark!}!mark!', 0, 1, '', 1, 'if ')
xnoremap <buffer> <silent> \if @=lh#style#surround('if(!cursorhere!){', '}!mark!', 0, 1, '', 1, 'if ')
nmap <buffer> \<k1> \1
xmap <buffer> \<k1> \1
nmap <buffer> <silent> \1 V\1
xnoremap <buffer> <silent> \1 @=lh#map#surround("#if 0!cursorhere!", "#else!mark!\n#endif!mark!", 1, 1, '', 1, "\1")
nmap <buffer> \<k0> \0
xmap <buffer> \<k0> \0
nmap <buffer> <silent> \0 V\0
xnoremap <buffer> <silent> \0 @=lh#map#surround("#if 0!cursorhere!", "#endif!mark!", 1, 1, '', 1, "\0")
nmap <buffer> <silent> \sc viw\sc
onoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nnoremap <buffer> <silent> ][ :call lh#dev#_goto_function_end()
nmap <buffer> ]M <Plug>NextFunctionEnd
nmap <buffer> ]m <Plug>NextFunctionStart
xnoremap <buffer> <silent> ` @=lh#map#surround("`", "`", 0, 0, '`>ll', 1)
nmap <buffer> <C-X>cbe viwcbe
xmap <buffer> <C-X>cbe ci,".cbegin(),".cend()
nmap <buffer> <C-X>rbe viwrbe
xmap <buffer> <C-X>rbe ci,".rbegin(),".rend()
nmap <buffer> <C-X>be viwbe
xmap <buffer> <C-X>be ci,".begin(),".end()
nmap <buffer> <silent> <M-v> viwö
xnoremap <buffer> <silent> <M-v> @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nnoremap <buffer> <C-F12> :call LoadHeaderFile(getline('.'),0)
nmap <buffer> <C-L>i <Plug>OpenIncludes
nmap <buffer> <C-X>u viwu
nmap <buffer> <M-RightMouse> <LeftMouse><Plug>PasteImpl
nmap <buffer> <M-LeftMouse> <LeftMouse><Plug>GotoImpl
nnoremap <buffer> <Plug>MoveToImpl :MOVETOIMPL
nnoremap <buffer> <Plug>PasteImpl :PASTEIMPL
nnoremap <buffer> <Plug>GotoImpl :GOTOIMPL 
nmap <buffer> <silent> <M-n> <Plug>AddMissingScope
nnoremap <buffer> <silent> <Plug>AddMissingScope :call lh#cpp#scope#_add_missing()
imap <buffer> cbe =lh#cpp#snippets#_begin_end('cbegin')
imap <buffer> rbe =lh#cpp#snippets#_begin_end('rbegin')
imap <buffer> be =lh#cpp#snippets#_begin_end('begin')
imap <buffer> <silent> se <Plug>SwitchEnum
imap <buffer> i <Plug>CompleteIncludes
imap <buffer> MI <Plug>MoveToImpl
imap <buffer> PI <Plug>PasteImpl
imap <buffer> GI <Plug>GotoImpl
inoremap <buffer> <silent> <expr> */ lh#brackets#closer("*/","*/","")
inoremap <buffer> <silent> <expr> /* lh#brackets#opener("/*",0,"","/*","*/",0,'')
inoremap <buffer> <expr> //@{ lh#map#insert_seq('//@{', '//@{\<cr\> !cursorhere!\<cr\>@}')
xnoremap <buffer> � @=SurroundBySubstitute('do{', '!cursorhere!}while(!mark!);!mark!', 0, 1, '', 1, 'do ')
inoremap <buffer> <silent> <expr> ; lh#cpp#brackets#semicolon()
inoremap <buffer> <silent> <expr> < lh#brackets#opener("<",0,"",function('lh#cpp#brackets#lt'),">",0,'')
inoremap <buffer> <silent> <expr> > lh#brackets#closer(">",">","")
inoremap <buffer> ?: =lh#map#build_map_seq('() ?!mark!:!mark!\<esc\>F(a')
nmap <buffer> <silent> ö viwö
xnoremap <buffer> <silent> ö @=lh#map#surround("/*", "*/", 0, 0, '`>ll', 1)
nmap <buffer> <silent> î <Plug>AddMissingScope
inoremap <buffer> <silent> <expr> [ lh#brackets#opener("[",0,"",function('lh#cpp#brackets#square_open'),"]",0,'')
imap <buffer> <silent> \cpw <Plug>ClosePreviewWindow
imap <buffer> <silent> \pw <Plug>PreviewWord
inoremap <buffer> <silent> <expr> ] lh#brackets#closer("]",function('lh#cpp#brackets#square_close'),"")
inoremap <buffer> <silent> <expr> ` lh#brackets#opener("`",0,"","`","`",1,'',{'is': 'comment\|doxygen'})
inoremap <buffer> <silent> <expr> { lh#brackets#opener("{",0,"",function('lh#cpp#brackets#curly_open'),"}",0,'')
inoremap <buffer> <silent> <expr> } lh#brackets#closer("}",function('lh#cpp#brackets#curly_close'),"")
inoreabbr <buffer> catch =lh#cpp#snippets#def_abbr('catch ', '\<c-f\>catch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> try =lh#cpp#snippets#def_abbr('try ', '\<c-f\>try{}catch(!mark!){!mark!}!mark!\<esc\>' .':PrivateCppSearchTry\<cr\>a\<c-f\>')=lh#map#eat_char('\s')
inoreabbr <buffer> namespace =lh#cpp#snippets#insert_if_not_after('namespace ', '\<c-f\>namespace <+namespace+>{<++>}// namespace <+namespace+>', 'using')=lh#map#eat_char('\s')
inoreabbr <buffer> delate delta
inoreabbr <buffer> firend friend
inoreabbr <buffer> vir virtual
iabbr <buffer> tpl template <=lh#map#eat_char('\s')
inoreabbr <buffer> pri ='private'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pro ='protected'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> pub ='public'.lh#cpp#snippets#insert_if_not_after(' ', ':\<CR\>', '[:,]')=lh#map#eat_char('\s')
inoreabbr <buffer> /= 0/*75a=a*/45<Left>R[
inoreabbr <buffer> /- 0/*75a-a*/45<Left>R[
inoreabbr <buffer> <silent> switch =lh#cpp#snippets#def_abbr('switch ', '\<c-f\>switch(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> do =lh#cpp#snippets#def_abbr('do ', '\<c-f\>do{!cursorhere!}while(!mark!);!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> while =lh#cpp#snippets#def_abbr('while ', '\<c-f\>while(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> for =lh#cpp#snippets#def_abbr('for ', { '! lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!;!mark!;!mark!){!mark!}!mark!', '  lh#cpp#use_cpp11()': '\<c-f\>for(!cursorhere!){!mark!}!mark!' })=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> else =lh#cpp#snippets#insert_if_not_before('else ', '\<c-f\>else{!cursorhere!}!mark!', 'if')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> elif =lh#cpp#snippets#def_abbr('elif ', '\<c-f\>else if(!cursorhere!) {!mark!}!mark!')=lh#map#eat_char('\s')
inoreabbr <buffer> <silent> if =lh#cpp#snippets#def_abbr('if ', '\<c-f\>if(!cursorhere!){!mark!}!mark!')=lh#map#eat_char('\s')
iabbr <buffer> <silent> #e =lh#map#no_context("#e ",'\<esc\>0i#endif')
iabbr <buffer> <silent> #i =lh#map#no_context('#i ','\<esc\>0i#ifdef')
iabbr <buffer> <silent> #n =lh#map#no_context("#n ",'\<esc\>0i#include')
iabbr <buffer> <silent> #d =lh#map#no_context("#d ",'\<esc\>0i#define')
inoreabbr <buffer> earse erase
inoreabbr <buffer> ocnst const
let &cpo=s:cpo_save
unlet s:cpo_save
setlocal keymap=
setlocal noarabic
setlocal noautoindent
setlocal backupcopy=
setlocal balloonexpr=
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=
setlocal cindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=g0,t0,h1s,i0,N-s
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/
setlocal complete=.,w,b,u,t,k
setlocal concealcursor=
setlocal conceallevel=0
setlocal completefunc=
setlocal nocopyindent
setlocal cryptmethod=
setlocal nocursorbind
setlocal nocursorcolumn
setlocal nocursorline
setlocal cursorlineopt=both
setlocal define=^\\s*#\\s*define
setlocal dictionary=~/.vim/plugged/lh-cpp/ftplugin/c/word.list
setlocal nodiff
setlocal equalprg=
setlocal errorformat=
setlocal noexpandtab
if &filetype != 'cpp'
setlocal filetype=cpp
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldmarker={{{,}}}
setlocal foldmethod=manual
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldtext=foldtext()
setlocal formatexpr=
setlocal formatoptions=croql
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatprg=
setlocal grepprg=
setlocal iminsert=0
setlocal imsearch=-1
setlocal include=^\\s*#\\s*include
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=#,a-z,A-Z,48-57,_
setlocal keywordprg=
setlocal nolinebreak
setlocal nolisp
setlocal lispwords=
set list
setlocal list
setlocal listchars=
setlocal makeencoding=
setlocal makeprg=
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal modifiable
setlocal nrformats=bin,octal,hex
set number
setlocal number
setlocal numberwidth=4
setlocal omnifunc=ccomplete#Complete
setlocal path=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal noscrollbind
setlocal scrolloff=-1
setlocal shiftwidth=4
setlocal noshortname
setlocal showbreak=
setlocal sidescrolloff=-1
setlocal signcolumn=auto
setlocal nosmartindent
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\	\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
setlocal statusline=
setlocal suffixesadd=.h,.c,.hpp,.cpp,.C,.h++,.c++,.hh
setlocal swapfile
setlocal synmaxcol=3000
if &syntax != 'cpp'
setlocal syntax=cpp
endif
setlocal tabstop=4
setlocal tagcase=
setlocal tagfunc=
setlocal tags=
setlocal termwinkey=
setlocal termwinscroll=10000
setlocal termwinsize=
setlocal textwidth=0
setlocal thesaurus=
setlocal noundofile
setlocal undolevels=-123456
setlocal varsofttabstop=
setlocal vartabstop=
setlocal wincolor=
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal wrap
setlocal wrapmargin=0
silent! normal! zE
let &fdl = &fdl
let s:l = 20 - ((19 * winheight(0) + 27) / 55)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 20
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 104 + 61) / 123)
exe 'vert 2resize ' . ((&columns * 104 + 61) / 123)
tabnext 5
set stal=1
badd +1 DtBlkFxEditor.cpp
badd +1 DtBlkFxEditor.h
badd +0 DtBlkFxProcessor.h
badd +0 misc_stuff.h
badd +0 MorphParam.h
badd +0 ParamsDelay.h
badd +0 ../src/DtBlkFxProcessor.cpp
badd +4 ../.gitignore
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOSc
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
