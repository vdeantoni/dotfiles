# Perforce
export P4CONFIG=~/p4/p4config.txt

# League Client setup
PLUGINATOR_BIN=/Users/vdeantoni/p4/depot/LoL/__MAIN__/DevRoot/Client/tools/pluginator/bin;
CT_BIN=/Users/vdeantoni/p4/depot/LoL/__MAIN__/DevRoot/Client/tools/client-tools/bin;
LCP_BIN=/Users/vdeantoni/p4/depot/LoL/__MAIN__/DevRoot/Client/tools/lcpuppeteer/bin;
export PATH=$PLUGINATOR_BIN:$CT_BIN:$LCP_BIN:$PATH

# Alias
alias reviews="open_command 'https://reviews.riotgames.com/cru?filter=outForReview'"

# Jira config
export JIRA_URL="https://jira.riotgames.com"
export JIRA_NAME="vdeantoni"
export JIRA_PREFIX=""
export JIRA_RAPID_BOARD="true"
export JIRA_DEFAULT_ACTION="dashboard"

pl() {
    set -x
    pluginator $1 rcp-fe-lol-$2 --env ci $@[3,-1]
    set +x
}

_cpc() {
    if [ -e $1 ]; then
        yes | cp -vf $1 $2
        chmod 644 $2
    fi
}

cpc() {
    local BASE_DIR=~/p4/depot/LoL/__MAIN__/DevRoot/Client/fe
    local SOURCE="${BASE_DIR}/rcp-fe-lol-perks"
    local TARGET="${BASE_DIR}/rcp-fe-lol-collections/src/lib/perks/addon"

    _cpc "${SOURCE}/src/app/components/$1.js" "${TARGET}/components/$1.js"
    _cpc "${SOURCE}/src/app/styles/components/$1.styl" "${TARGET}/styles/components/$1.styl"
    _cpc "${SOURCE}/src/app/templates/components/$1.hbs" "${TARGET}/templates/components/$1.hbs"

    echo "Done"
}