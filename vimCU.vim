"***********************************************************************
	" It is based on the comment/uncomment package from github:"
  " Comment / UnComment
  "
  " Comment differently single line comments and multiple line comments.
  " Strings that begins and ends comments are contained in variables:
  " b:beginOfCommentSingle, b:endOfCommentSingle, b:beginOfCommentMulti,
  " b:endOfCommentMulti; these variables have to be defined in order to
  " use Comment and UnComment. The variable b:CommentType specify which
  " comment are available, this variable contains one or more of the
  " following flag 's', 'm'; 's' means that single line comments are
  " available, 'm' means that multiple line comments are available. If
  " 'm' is not set, multiple line comments are threaded line by line as
  " a single comment.
	"
"***********************************************************************

" comment a single line at lineno
function! SingleLineComment(lineno)
  let s = getline(a:lineno) " fet the line at lineno to s
  let s = substitute(s, "^", b:beginOfCommentSingle, "") "insert comment beginning at bol
	let s = substitute(s, "$", b:endOfCommentSingle, "") " insert commend ending at eol
  call setline(a:lineno, s) " set the whole line at lineno by s"
endfunction

" comment a multilines 
function! MultiLineComment(line1, line2)
  if match(b:CommentType, "m") == -1  " multilne comments disabled
    let i = a:line1
    while i <= a:line2  " comment each line by itself
      call SingleLineComment(i)
      let i = i+1
    endwhile
  else  " multiline comments enabled
    call append(a:line2, b:endOfCommentMulti)
    call append(a:line1 - 1, b:beginOfCommentMulti)
  endif
endfunction

function! SingleLineUnComment(lineno)
  let line = getline(a:lineno)
  let line = substitute(line, "^".escape(b:beginOfCommentSingle, "*"), "", "")
  let line = substitute(line, escape(b:endOfCommentSingle, "*")."$", "", "")
  call setline(a:lineno, line)
endfunction

function! MultiLineUnComment(line1, line2)
  if match(b:CommentType, "m") == -1  " multilne comments disabled
    let i = a:line1
    while i <= a:line2  " uncomment each line by itself
      call SingleLineUnComment(i)
      let i = i+1
    endwhile
  else  " multiline comments enabled
    execute a:line2."d"
    execute a:line1."d"
  endif
endfunction

function! Comment(line1, line2)   " comment part of text
"Decho("in comment function : " )
"Decho("b:beginOfCommentSingle =  ". b:beginOfCommentSingle)
  if (a:line2 - a:line1) == 0 " single line comment
    call SingleLineComment(a:line1)
  else  " multi line comment
    call MultiLineComment(a:line1, a:line2)
  endif
endfunction

function! UnComment(line1, line2)   " uncomment part of text
  if (a:line2 - a:line1) == 0 " single line comment
    call SingleLineUnComment(a:line1)
  else  " multi line comment
    call MultiLineUnComment(a:line1, a:line2)
  endif
endfunction

function! MatchType( list )
" 	Decho("ft = " . &ft)
	return index(a:list, &ft) >= 0
endfunction

function! GetCommentStyle()
" 	Decho("in getcommentstyle")
	if MatchType(g:CommentStyleC)
		return "c"
	elseif MatchType(g:CommentStyleSh)
		return "sh"
	elseif MatchType(g:CommentStyleLisp)
		return "lisp"
	elseif MatchType(g:CommentStyleLua)
		return "lua"
	elseif MatchType(g:CommentStyleSml)
		return "sml"
	elseif MatchType(g:CommentStylePs)
		return "ps"
	elseif MatchType(g:CommentStyleHtml)
		return "html"
	elseif MatchType(g:CommentStyleFortran)
		return "fortran"
	elseif MatchType(g:CommentStyle4th)
		return "forth"
	elseif MatchType(g:CommentStyleVim)
		return "vim"
	else
" 		 Decho("in txt")
		return "txt"
	end
endfunction

function! SetCommentMarks()
	let b:CommentStyle = GetCommentStyle()
	"Decho("setcomment marks: " )
	"Decho("just enter fucntion b:beginOfCommentSingle =  ". b:beginOfCommentSingle)
		let b:beginOfCommentMulti = ""
		let b:endOfCommentMulti = ""
	if b:CommentStyle == "c" 
		let b:beginOfCommentSingle = "// "
		let b:endOfCommentSingle = ""
		let b:beginOfCommentMulti = "/* "
		let b:endOfCommentMulti = " */"
	elseif  b:CommentStyle == "sh"
		let b:beginOfCommentSingle = "# "
		let b:endOfCommentSingle = ""
	elseif  b:CommentStyle == "lisp"
		let b:beginOfCommentSingle = "; "
		let b:endOfCommentSingle = ""
	elseif  b:CommentStyle == "vim"
		let b:beginOfCommentSingle = "\" "
		let b:endOfCommentSingle = ""
	elseif  b:CommentStyle == "lua"
		let b:beginOfCommentSingle = "-- "
		let b:endOfCommentSingle = ""
		let b:beginOfCommentMulti = "--[[ "
		let b:endOfCommentMulti = "--]]"
	elseif  b:CommentStyle == "sml"
		let b:beginOfCommentSingle = "(* "
		let b:endOfCommentSingle = " *)"
	elseif  b:CommentStyle == "ps"
		let b:beginOfCommentSingle = "% "
		let b:endOfCommentSingle = ""
	elseif  b:CommentStyle == "html"
		let b:beginOfCommentSingle = "<!--"
		let b:endOfCommentSingle = "-->"
		let b:beginOfCommentSingle = "<!--"
		let b:endOfCommentSingle = "-->"
	elseif  b:CommentStyle == "fortran"
		let b:beginOfCommentSingle = "! "
		let b:endOfCommentSingle = ""
	elseif  b:CommentStyle == "forth"
		let b:beginOfCommentSingle = "\\ "
		let b:endOfCommentSingle = ""
		let b:beginOfCommentMulti = "( "
		let b:endOfCommentMulti = " )"
	else
" 		Decho("commentstype = unknown")
		let b:beginOfCommentSingle = ""
		let b:endOfCommentSingle = ""
	endif
	if b:beginOfCommentMulti == ""
		 let b:beginOfCommentMulti = b:beginOfCommentSingle  
		 let b:endOfCommentMulti = b:endOfCommentSingle  
	 endif
endfunction

" assign function to user defined command Commend and UnComment
command! -range Comment call Comment(<line1>, <line2>)
command! -range UnComment call UnComment(<line1>, <line2>)

let g:CommentStyleC = [ "c", "C", "cc", "cpp", "cxx", "H", "h", "hpp", "hxx", "java", "js", "objc" ]
let g:CommentStyleSh = [ "sh", "awk", "bash", "cmake", "csh", "ksh", "m4", "makefile", "Makefile", "ruby", "perl", "pl", "python", "sed", "tcl", "tmux", "gnuplot" ] 
let g:CommentStyleLisp = [ "lisp", "asm", "masm", "nasm", "tasm", "s", "lsp", "newlisp", "scm" ]
let g:CommentStyleLua= [ "lua", "occam", "hs", "haskell"]
let g:CommentStyleSml = [ "sml", "ocaml", "ml"]
let g:CommentStyleHtml = [ "html", "htm" ]
let g:CommentStyleVim= [ "vim"]
let g:CommentStylePs = [ "postscr", "ps", "pdf", "matlab", "m" ]
let g:CommentStyleFortran = [ "fortran", "f77", "f" ]
let g:CommentStyle4th= [ "forth", "fth", "frt", "4th", "ft", "fs"]


" default settings
" let b:CommentType = "s"   " only single line comments enabled by default
let b:CommentType = "m"   " only single line comments enabled by default
let b:endOfCommentSingle = ""
let b:beginOfCommentSingle = ""
au BufReadPost,BufNewFile,BufCreate * call SetCommentMarks()

" comment shortcut
map ;; :Comment<RETURN>    " comment lines
map ;u :UnComment<RETURN>  " uncomment lines
map ;k vip:Comment<RETURN> " comment a block of code
map ;uk vip:UnComment<RETURN> " uncomment a block of code

