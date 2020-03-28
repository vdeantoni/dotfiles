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

# Custom variables
BAT_WITH_FALLBACK='bat --style=numbers --color=always {} || cat {} || tree -C {}';
FZF_FD_OPTS="--hidden --follow --exclude .git --exclude node_modules --exclude p4"

# User settings
export FZF_BIND_CHANGE="--bind 'change:top'"
export FZF_BIND_SORT="--bind 'f2:toggle-sort'"
export FZF_BIND_SELECT_ALL="--bind 'ctrl-a:select-all'"
export FZF_BIND_DESELECT_ALL="--bind 'ctrl-s:deselect-all'"
export FZF_BIND_COPY="--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_BIND_TOGGLE_PREVIEW="--bind '?:toggle-preview'"
export FZF_BIND_PEEK="--bind 'ctrl-space:execute($BAT_WITH_FALLBACK)'"
export FZF_BIND_OPEN="--bind 'ctrl-e:execute($EDITOR {+})+abort,ctrl-v:execute(code {+})+abort,ctrl-o:execute(open {+})+abort'"
export FZF_BIND_DELETE="--bind 'ctrl-x:execute(rm -i {+})+abort'"

export FZF_PREVIEW="--preview '($BAT_WITH_FALLBACK) 2> /dev/null | head -200'"
export FZF_PREVIEW_WINDOW_HIDDEN="--preview-window=:hidden"
export FZF_PREVIEW_WINDOW="--preview-window=right:wrap"

export FZF_DEFAULT_COMMAND="fd $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_DEFAULT_OPTS="
    --no-mouse
    --layout=reverse
    -0
    --info=inline
    --multi
    --no-height
    $FZF_BIND_CHANGE
    $FZF_BIND_SORT
    $FZF_BIND_SELECT_ALL
    $FZF_BIND_DESELECT_ALL
    $FZF_BIND_COPY
    $FZF_BIND_TOGGLE_PREVIEW
    $FZF_PREVIEW
    $FZF_PREVIEW_WINDOW_HIDDEN
    $FZF_BIND_PEEK
    $FZF_BIND_OPEN
    $FZF_BIND_DELETE
    "

export FZF_ALT_C_OPTS="--multi=0 $FZF_PREVIEW_WINDOW"
export FZF_CTRL_T_OPTS="$FZF_PREVIEW_WINDOW"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  command fd --hidden --follow --exclude ".git" --exclude "node_modules" --exclude "p4" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  command fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" --exclude "p4" . "$1"
}

# Integration with z
# like normal z when used with arguments but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1

# Deps
alias fz="fzf-noempty --bind 'tab:toggle,shift-tab:toggle+beginning-of-line+kill-line,ctrl-j:toggle+beginning-of-line+kill-line,ctrl-t:top' --color=light -1 -m"
fzf-noempty () {
	local in="$(</dev/stdin)"
	test -z "$in" && (
		exit 130
	) || {
		ec "$in" | fzf "$@"
	}
}
ec () {
	if [[ -n $ZSH_VERSION ]]
	then
		print -r -- "$@"
	else
		echo -E -- "$@"
	fi
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Homebrew
# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | fzf -m)

  if [[ $inst ]]; then
    for prog in $(echo $inst);
    do; brew install $prog; done;
  fi
}
# Update (one or multiple) selected application(s)
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | fzf -m)

  if [[ $upd ]]; then
    for prog in $(echo $upd);
    do; brew upgrade $prog; done;
  fi
}
# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | fzf -m)

  if [[ $uninst ]]; then
    for prog in $(echo $uninst);
    do; brew uninstall $prog; done;
  fi
}

# Homebrew Cask
# Install or open the webpage for the selected application
# using brew cask search as input source
# and display a info quickview window for the currently marked application
install() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
}
# Uninstall or open the webpage for the selected application
# using brew list as input source (all brew cask installed applications)
# and display a info quickview window for the currently marked application
uninstall() {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read input
        if [ $input = "u" ] || [ $input = "U" ]; then
            brew cask uninstall $token
        fi
        if [ $input = "h" ] || [ $token = "h" ]; then
            brew cask home $token
        fi
    fi
}