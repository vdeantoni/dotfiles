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
export JIRA_PREFIX="LCT"

pl() {
    set -x
    pluginator $1 rcp-fe-lol-$2 --env ci $@[3,-1]
    set +x
}