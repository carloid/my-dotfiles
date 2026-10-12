" blowtorch.vim - Ported from .emacs configuration with proper status line and menu styling
if !has('gui_running') && &t_Co < 256
    finish
endif

set termguicolors
set background=dark

hi clear
if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'blowtorch'

let s:fg_default = { "gui": "#d0b28a" } " Main text / tan (#d0b28a)[cite: 1]
let s:fg_white   = { "gui": "#ffffff" } " Keywords / white[cite: 1]
let s:fg_green   = { "gui": "#8ae797" } " Types / light green
let s:fg_yellow  = { "gui": "#fafa00" } " Comments / yellow[cite: 1]
let s:fg_number  = { "gui": "#95decb" } " Numbers (#95decb)
let s:bg0        = { "gui": "#1a1a1a" } " Main background gray10 (#1a1a1a)[cite: 1]
let s:select     = { "gui": "#0000ff" } " Selection region blue[cite: 1]
let s:curLine    = { "gui": "#8fbc8f" } " Highlight background darkseagreen2[cite: 1]
let s:curFg      = { "gui": "#000080" } " Highlight text navy blue[cite: 1]

" Status bar palette based on zx.vim structure
let s:sl_act_bg  = s:fg_default         " Active status line background (tan #d0b28a)[cite: 1, 2]
let s:sl_act_fg  = s:bg0                " Active status line text (dark #1a1a1a)[cite: 1, 2]
let s:sl_inact_bg= { "gui": "#3a3a3a" } " Unfocused status line background (menuBg style)[cite: 2]
let s:sl_inact_fg= s:fg_default         " Unfocused status line text (tan #d0b28a)[cite: 1, 2]
let s:split_fg   = { "gui": "#555555" } " Vertical split line color

function! s:h(group, style)
   execute "hi!" a:group
        \ "guifg=" (has_key(a:style, "fg")  ? a:style.fg.gui : "NONE") 
        \ "guibg=" (has_key(a:style, "bg")  ? a:style.bg.gui : "NONE")
        \ "guisp=" (has_key(a:style, "sp")  ? a:style.sp.gui : "NONE")
        \ "gui="   (has_key(a:style, "gui") ? a:style.gui    : "NONE")
endfunction

" Default GUI

call s:h("Normal",         { "fg": s:fg_default, "bg": s:bg0 })
call s:h("EndOfBuffer",    { "fg": s:fg_default, "bg": s:bg0 })
call s:h("Visual",         { "bg": s:select, "fg": s:fg_white })
call s:h("Comment",        { "fg": s:fg_yellow })
call s:h("String",         { "fg": s:fg_default, "bg": s:bg0 })
call s:h("Character",      { "fg": s:fg_default, "bg": s:bg0 })
call s:h("Number",         { "fg": s:fg_number })
call s:h("Boolean",        { "fg": s:fg_number })
call s:h("Float",          { "fg": s:fg_number })

" Syntax / Keywords / Identifiers

call s:h("Keyword",        { "fg": s:fg_white })
call s:h("Statement",      { "fg": s:fg_white })
call s:h("Conditional",    { "fg": s:fg_white })
call s:h("Repeat",         { "fg": s:fg_white })
call s:h("Label",          { "fg": s:fg_white })
call s:h("Operator",       { "fg": s:fg_white })
call s:h("Exception",      { "fg": s:fg_white })

call s:h("Identifier",     { "fg": s:fg_white })
call s:h("Function",       { "fg": s:fg_white })

" Types / Structs / Classes / Enums

call s:h("Type",           { "fg": s:fg_green })
call s:h("Structure",      { "fg": s:fg_white })
call s:h("StorageClass",   { "fg": s:fg_white })
call s:h("Typedef",        { "fg": s:fg_green })

" Preprocessor / Directives

call s:h("PreProc",        { "fg": s:fg_green })
call s:h("Include",        { "fg": s:fg_green })
call s:h("Define",         { "fg": s:fg_green })
call s:h("Macro",          { "fg": s:fg_white })
call s:h("PreCondit",      { "fg": s:fg_green })

" Constants / Enum Values

call s:h("Constant",       { "fg": s:fg_white })
call s:h("Special",        { "fg": s:fg_white })
call s:h("SpecialComment", { "fg": s:fg_yellow })
call s:h("Todo",           { "fg": s:fg_white, "bg": s:bg0 })

" UI Status Bar, Splits & Menus (Structured like zx.vim)

call s:h("CursorLine",     { "bg": s:curLine })
call s:h("LineNr",         { "fg": s:fg_default })
call s:h("CursorLineNr",   { "fg": s:fg_green, "bg": s:curLine })
call s:h("WildMenu",       { "bg": s:sl_act_bg, "fg": s:sl_act_fg, "gui": "bold" })
call s:h("StatusLine",     { "fg": s:sl_act_fg, "bg": s:sl_act_bg, "gui": "bold" })
call s:h("StatusLineNC",   { "fg": s:sl_inact_fg, "bg": s:sl_inact_bg })
call s:h("VertSplit",      { "fg": s:split_fg, "bg": s:bg0 })

" Popup Menu (Pmenu) & Selected Suggestion
call s:h("Pmenu",          { "fg": s:fg_default, "bg": { "gui": "#3a3a3a" } })
call s:h("PmenuSel",       { "fg": s:bg0, "bg": s:fg_default, "gui": "bold" })
call s:h("PmenuSbar",      { "bg": { "gui": "#3a3a3a" } })
call s:h("PmenuThumb",     { "bg": s:fg_default })

" Custom C++ Syntax Rules (Ensures ALL_CAPS constants/enums and macros map to white)
augroup BlowtorchCpp
    autocmd!
    " Match standard PascalCase / CamelCase types (Green)
    autocmd FileType cpp,c syntax match cCustomType /\<[A-Z][a-z0-9_]\+[a-zA-Z0-9_]*\>/
    " Match ALL_CAPS constants, enum values, and macros (White)
    autocmd FileType cpp,c syntax match cAllCapsConstant /\<[A-Z][A-Z0-9_]*\>/
    autocmd FileType cpp,c syntax match sPragmaArg /\v^\s*#\s*pragma\s+\zs\w+/
augroup END

hi link cCustomType Type
hi link cAllCapsConstant Constant
hi link cConstant Constant
hi link cppConstant Constant
hi link cDefine Macro
hi link cMacro Macro
hi link cIncluded String

" Clean terminal fallbacks without conflicting overrides
hi CursorLine   cterm=NONE ctermbg=darkgreen ctermfg=blue
hi CursorLineNr cterm=NONE ctermbg=darkgreen ctermfg=blue
hi VertSplit    cterm=NONE
