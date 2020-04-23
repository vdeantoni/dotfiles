# language
export LANG=en_US.UTF-8

# Preferred editor
export EDITOR='nvim'

# bat
export BAT_THEME="Nord"

# fzf
export FZF_HIDE_VCS_FOLDERS="true"
export FZF_COMPLETION_TRIGGER='zz'

export FZF_VIEW_WITH_FALLBACK='
([[ -f {} && ($(file --mime {}) =~ image) ]] && (catimg -w 100 {})) ||
([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) ||
([[ -d {} ]] && (tree -C {} | less)) ||
echo {}'
export FZF_VIEW_IN_FINDER='
([[ -d {} ]] && (echo {} | xargs open)) ||
(echo $(dirname {}) | xargs open)'

export FZF_POINTER="--prompt='∼ ' --pointer='▶' --marker='·'"
export FZF_MARGIN="--margin 0,0,0,0"

export FZF_COLOR="
--color='hl:148'
--color='hl+:154'
--color='pointer:032'
--color='marker:003'
--color='bg+:237'
--color='gutter:008'
"

export FZF_BIND_CHANGE="--bind 'change:top'"
export FZF_BIND_SORT="--bind 'f2:toggle-sort'"
export FZF_BIND_SELECT_ALL="--bind 'ctrl-a:select-all'"
export FZF_BIND_DESELECT_ALL="--bind 'ctrl-s:deselect-all'"
export FZF_BIND_COPY="--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_BIND_PEEK="--bind 'ctrl-space:execute($FZF_VIEW_WITH_FALLBACK)'"
export FZF_BIND_OPEN="--bind 'ctrl-e:execute(echo {+} | xargs -o $EDITOR),ctrl-v:execute(code {+}),ctrl-o:execute(echo {+} | xargs open),ctrl-f:execute($FZF_VIEW_IN_FINDER)'"
export FZF_BIND_DELETE="--bind 'ctrl-x:execute(rm -i {+})+abort'"
export FZF_BIND_TOGGLE_PREVIEW="--bind '?:toggle-preview'"
export FZF_BIND_TOGGLE_PREVIEW_WRAP="--bind 'f3:toggle-preview-wrap'"
export FZF_BIND_SCROLL_UP_PREVIEW="--bind 'alt-up:preview-up'"
export FZF_BIND_SCROLL_DOWN_PREVIEW="--bind 'alt-down:preview-down'"

export FZF_PREVIEW="--preview '($FZF_VIEW_WITH_FALLBACK) 2> /dev/null | head -200'"
export FZF_PREVIEW_WINDOW_HIDDEN="--preview-window=:hidden"
export FZF_PREVIEW_WINDOW="--preview-window=right:wrap"

export FZF_DEFAULT_COMMAND="fzf-find"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_DEFAULT_OPTS="
--no-mouse
--layout=reverse
--info=inline
--height=80%
-0
--multi
$FZF_POINTER
$FZF_MARGIN
$FZF_COLOR
$FZF_BIND_CHANGE
$FZF_BIND_SORT
$FZF_BIND_SELECT_ALL
$FZF_BIND_DESELECT_ALL
$FZF_BIND_COPY
$FZF_BIND_PEEK
$FZF_BIND_OPEN
$FZF_BIND_DELETE
$FZF_BIND_TOGGLE_PREVIEW
$FZF_BIND_TOGGLE_PREVIEW_WRAP
$FZF_BIND_SCROLL_UP_PREVIEW
$FZF_BIND_SCROLL_DOWN_PREVIEW
$FZF_PREVIEW
$FZF_PREVIEW_WINDOW_HIDDEN
"

export FZF_ALT_C_OPTS="--multi=0 $FZF_PREVIEW_WINDOW"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_WINDOW"