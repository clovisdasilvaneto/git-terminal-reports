#!/usr/local/bin/bash
# OUTPUT-COLORING

set -o errexit ; set -o nounset

cd /Users/miguelangelo/Liferay/GS/git/bg/upstream-bgp

git pull -r origin develop

GIT_DAILY_LOG=$(git log --oneline --after="3 days ago" --reverse --author="gallindo" --date=iso-strict-local --pretty=format:"%ad %s (%an)")

#declare -A JIRA_ISSUES

while IFS= read -r line
do
    COMMIT_DATE=$(echo "$line" | awk '{print $1}')
    COMMIT_MESSAGE=$(echo "$line" | cut -c26-)

    JIRA_ISSUE_ID=$(echo "$line" | awk '{print $2}')

    JIRA_ISSUE_DESCRIPTION=$(jira show -o summary $JIRA_ISSUE_ID)

    echo "$COMMIT_DATE | [$JIRA_ISSUE_ID - $JIRA_ISSUE_DESCRIPTION] | $COMMIT_MESSAGE"
done <<< "$GIT_DAILY_LOG"

cd -
