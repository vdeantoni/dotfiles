#!/usr/local/bin/zsh

ln -sv "$PWD/zsh/.alias.zsh" ~
ln -sv "$PWD/zsh/.fzf.zsh" ~
ln -sv "$PWD/zsh/.iterm2.zsh" ~
ln -sv "$PWD/zsh/.p10k.zsh" ~
ln -sv "$PWD/zsh/.riot.zsh" ~
ln -sv "$PWD/zsh/.variables.zsh" ~
ln -sv "$PWD/zsh/.zshrc" ~

ln -sv "$PWD/zsh/plugins/forgit" "$ZSH/custom/plugins"
ln -sv "$PWD/zsh/plugins/nodenv" "$ZSH/custom/plugins"

ln -sv "$PWD/bin/fzf-find" "/usr/local/bin"
chmod 755 /usr/local/bin/fzf-find

ln -sv "$PWD/.gitconfig" ~
