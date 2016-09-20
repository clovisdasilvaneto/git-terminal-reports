#!/bin/sh -e
# OUTPUT-COLORING

#git shortlog -s -n -e b8bc8fca15e0303681b9b59772ff487d933a5d1b..HEAD
#git shortlog -s -n -e
#osascript -e 'display notification "Notification text" with title "Title"'

set -o errexit ; set -o nounset

# Colors
reset_color="\033[0m"            # Reset color
bold_format="\033[1;33;44m"
bold_format_purple="\033[1;33;35m"


cd /Users/miguelangelo/Liferay/GS/git/bg/upstream-bgp

git pull -r origin develop

#Between 07/13/2016 and 09/14/2016
#GIT_SHORT_LOG=$(git shortlog --summary --numbered --email b8bc8fca15e0303681b9b59772ff487d933a5d1b..HEAD)

#Since 09/15/2016
GIT_SHORT_LOG=$(git shortlog --summary --numbered --email 2b02fac63827fb843c61dd0bc5df07c6a63570cb..HEAD)


#GIT_LIST_PULL_REQUESTS=$(java -jar /Users/miguelangelo/Development/workspace/github-personal-statistics/build/libs/github-personal-statistics.jar)

echo "${bold_format_purple}Since 09/15/2016${reset_color}\n\n$GIT_SHORT_LOG\n\n"

#echo "$GIT_LIST_PULL_REQUESTS"

osascript -e "display notification \"${GIT_SHORT_LOG}\" with title \"Summary\""

cd -
