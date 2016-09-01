#!/bin/sh -e
# OUTPUT-COLORING

#git shortlog -s -n -e b8bc8fca15e0303681b9b59772ff487d933a5d1b..HEAD
#git shortlog -s -n -e
#osascript -e 'display notification "Notification text" with title "Title"'

set -o errexit ; set -o nounset

cd /Users/miguelangelo/Liferay/GS/git/bg/upstream-bgp

git pull -r origin develop

GIT_SHORT_LOG=$(git shortlog --summary --numbered --email b8bc8fca15e0303681b9b59772ff487d933a5d1b..HEAD)

GIT_LIST_PULL_REQUESTS=$(java -jar /Users/miguelangelo/Development/workspace/github-personal-statistics/build/libs/github-personal-statistics.jar)

echo "$GIT_SHORT_LOG"

echo "$GIT_LIST_PULL_REQUESTS"

osascript -e "display notification \"${GIT_SHORT_LOG}\" with title \"Summary\""

cd -
