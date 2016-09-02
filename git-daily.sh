#!/bin/sh -e
# OUTPUT-COLORING

#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

set -o errexit ; set -o nounset

# Colors
reset_color="\033[0m"            # Reset color
summary_color="\033[0;32m"
issue_color="\033[0;33m"          # Yellow
date_color="\033[0;35"

cd /Users/miguelangelo/Liferay/GS/git/bg/upstream-bgp

git pull -r origin develop

function lastworkingday()
{
    if [[ "1" == "$(date +%u)" ]]; then
        echo "last friday"
    else
        echo "yesterday"
    fi
}

AUTHOR=${AUTHOR:="$(git config --global user.name)"}
SINCE=${SINCE:="$(lastworkingday)"}

GIT_DAILY_LOG=$(git log --oneline --after="$SINCE" --reverse --author="$AUTHOR" --date=iso-strict-local --pretty=format:"%ad %s (%an)")

#declare -A JIRA_ISSUES

while IFS= read -r line
do
    COMMIT_DATE=$(echo "$line" | awk '{print $1}')
    COMMIT_MESSAGE=$(echo "$line" | cut -c26-)

    JIRA_ISSUE_ID=$(echo "$line" | awk '{print $2}')

    JIRA_ISSUE_DESCRIPTION=$(jira show -o summary $JIRA_ISSUE_ID)

    echo "$COMMIT_DATE \n    [${issue_color}$JIRA_ISSUE_ID${reset_color} - ${summary_color}$JIRA_ISSUE_DESCRIPTION${reset_color}] \n        $COMMIT_MESSAGE"
done <<< "$GIT_DAILY_LOG"

cd -
