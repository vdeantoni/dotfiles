# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
export FZF_COMPLETION_TRIGGER='zz'
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Custom variables
VIEW_WITH_FALLBACK='
([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) ||
([[ -d {} ]] && tree -C {}) ||
echo {}'

# User settings
FZF_POINTER="--prompt='~ ' --pointer='▶' --marker='✗'"
FZF_MARGIN="--margin 0,0,0,0"

# --color='fg:0'
# --color='bg:0'
# --color='fg+:0'
# --color='bg+:0'
# --color='preview-fg:0'
# --color='preview-bg:0'
# --color='hl:0'
# --color='hl+:0'
# --color='gutter:0'
# --color='info:0'
# --color='border:0'
# --color='prompt:0'
# --color='pointer:0'
# --color='marker:0'
# --color='header:0'
FZF_COLOR="
--color='hl:148'
--color='hl+:154'
--color='pointer:032'
--color='marker:010'
--color='bg+:237'
--color='gutter:008'
"

FZF_BIND_CHANGE="--bind 'change:top'"
FZF_BIND_SORT="--bind 'f2:toggle-sort'"
FZF_BIND_SELECT_ALL="--bind 'ctrl-a:select-all'"
FZF_BIND_DESELECT_ALL="--bind 'ctrl-s:deselect-all'"
FZF_BIND_COPY="--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
FZF_BIND_PEEK="--bind 'ctrl-space:execute($VIEW_WITH_FALLBACK)'"
FZF_BIND_OPEN="--bind 'ctrl-e:execute(echo {+} | xargs -o $EDITOR),ctrl-v:execute(code {+}),ctrl-o:execute(open_command {+})"
FZF_BIND_DELETE="--bind 'ctrl-x:execute(rm -i {+})+abort'"
FZF_BIND_TOGGLE_PREVIEW="--bind '?:toggle-preview'"
FZF_BIND_TOGGLE_PREVIEW_WRAP="--bind 'f3:toggle-preview-wrap'"
FZF_BIND_SCROLL_UP_PREVIEW="--bind 'alt-up:preview-up'"
FZF_BIND_SCROLL_DOWN_PREVIEW="--bind 'alt-down:preview-down'"

FZF_PREVIEW="--preview '($VIEW_WITH_FALLBACK) 2> /dev/null | head -200'"
FZF_PREVIEW_WINDOW_HIDDEN="--preview-window=:hidden"
FZF_PREVIEW_WINDOW="--preview-window=right:wrap"

export FZF_DEFAULT_COMMAND="fd $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_DEFAULT_OPTS="
--no-mouse
--layout=reverse
-0
--info=inline
--multi
--height=80%
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