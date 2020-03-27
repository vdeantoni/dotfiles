# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# User settings
export FZF_BIND_CHANGE="--bind 'change:top'"
export FZF_BIND_SELECT_ALL="--bind 'ctrl-a:select-all'"
export FZF_BIND_DESELECT_ALL="--bind 'ctrl-s:deselect-all'"
export FZF_BIND_COPY="--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_BIND_TOGGLE_PREVIEW="--bind '?:toggle-preview'"
export FZF_BIND_PEEK="--bind 'ctrl-space:execute(bat --style=numbers --color=always {} || cat {} || tree -C {})'"
export FZF_BIND_OPEN="--bind 'ctrl-e:execute($EDITOR {+})+abort,ctrl-v:execute(code {+})+abort,ctrl-o:execute(open {+})+abort'"

export FZF_PREVIEW_WINDOW="--preview-window='right:wrap'"
export FZF_PREVIEW="--preview-window=:hidden --preview '(bat --style=numbers --color=always {} || cat {} || tree -C {}) 2> /dev/null | head -200'"

export FZF_DEFAULT_OPTS="
    --no-mouse
    --layout=reverse
    -0
    --info=inline
    --multi
    --no-height
    $FZF_BIND_CHANGE
    $FZF_BIND_SELECT_ALL
    $FZF_BIND_DESELECT_ALL
    $FZF_BIND_COPY
    $FZF_BIND_TOGGLE_PREVIEW
    $FZF_PREVIEW
    $FZF_BIND_PEEK
    $FZF_BIND_OPEN
    "

export FZF_ALT_C_OPTS="--multi=0 $FZF_PREVIEW_WINDOW"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_WINDOW"

# FZF_BIND_OPTS="--bind 'enter:execute(less {})'"
# # FZF_BIND_OPTS="--bind 'return:execute(code {+})+abort,ctrl-e:execute($EDITOR {})+abort,f2:toggle-preview,ctrl-a:select-all,ctrl-y:execute-silent(echo {+} | pbcopy),f4:execute(rm -i {+})+abort'"




# Integration with z
# like normal z when used with arguments but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}