eval "$(nodenv init -)"

nodenv-doctor() {
    curl -fsSL https://github.com/nodenv/nodenv-installer/raw/master/bin/nodenv-doctor | bash
}

