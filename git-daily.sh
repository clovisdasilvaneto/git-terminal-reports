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

set -o errexit ;
set -o nounset ;
set -o pipefail ;
#set -u ;
#set -x

# Colors
reset_color="\033[0m"            # Reset color
summary_color="\033[0;32m"
issue_color="\033[0;33m"
issue_color_bold="\033[1;33m"
date_color="\033[0;35"
bold_format="\033[1;33;44m"
bold_format_purple="\033[1;33;35m"
complete_80_col="                                                                     "
issue_indentation="    "
commit_indentation=$issue_indentation$issue_indentation

#List Remote Git Branches By Author sorted by committerdate
#git for-each-ref --format='%(committerdate) %09 %(authorname) %09 %(refname)' | sort -k5n -k2M -k3n -k4n

#pr
#for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %an %s" $branch | head -n 1` \\t$branch; done | sort -r | grep Miguel

verifyRequirements()
{

  echo "\n${bold_format_purple}Verifying requirements...${reset_color}"


  JIRA_CMD_DIR=$(jira &> /dev/null || echo "not found")


  if [[ ${JIRA_CMD_DIR} == "not found" ]]; then
    echo "\n${issue_color_bold}Install jira cmd client and run this script again.${reset_color}"
    echo "\n${summary_color}running${reset_color} npm install -g jira-cmd ${summary_color}and then${reset_color} jira config\n"
    exit
  fi


}

goToRepositoryDir()
{
    cd /Users/miguelangelo/Liferay/GS/git/bg/upstream-bgp
}

goBackToTheLastDir()
{
    cd -
}

updateReporitory()
{
  git pull -r origin develop
}

lastworkingday()
{
    if [[ "1" == "$(date +%u)" ]]; then
        echo "last friday"
    else
        echo "yesterday"
    fi
}

printCommitsAlreadyInUpstream()
{

  echo "\n${bold_format_purple}Merged Commits${reset_color}"

  GIT_DAILY_LOG=$(git log --oneline --after="$SINCE" --author="$AUTHOR" --date=iso-strict-local --pretty=format:"%ad %s" | sort --reverse)

  LAST_JIRA_ISSUE_ID=""
  LAST_JIRA_ISSUE_DESCRIPTION=""
  LAST_COMMIT_DATE=""

  while IFS= read -r line
  do
      COMMIT_DATE=$(echo "$line" | cut -c1-10)
      COMMIT_MESSAGE=$(echo "$line" | cut -c26-)

      JIRA_ISSUE_ID=$(echo "$line" | awk '{print $2}' | cut -c1-7)

      if [[ $LAST_COMMIT_DATE != $COMMIT_DATE ]]; then
        LAST_COMMIT_DATE=$COMMIT_DATE
        LAST_JIRA_ISSUE_ID=""
        echo "${issue_color_bold}$COMMIT_DATE$complete_80_col${reset_color}"
      fi

      if [[ $LAST_JIRA_ISSUE_ID != $JIRA_ISSUE_ID ]]; then
        JIRA_ISSUE_DESCRIPTION=$(jira show -o summary $JIRA_ISSUE_ID)
        LAST_JIRA_ISSUE_ID=$JIRA_ISSUE_ID
        LAST_JIRA_ISSUE_DESCRIPTION=$JIRA_ISSUE_DESCRIPTION
        echo "$issue_indentation[${issue_color}$JIRA_ISSUE_ID${reset_color} - ${summary_color}$JIRA_ISSUE_DESCRIPTION${reset_color}]"
      fi

      echo "$commit_indentation$COMMIT_MESSAGE"
  done <<< "$GIT_DAILY_LOG"
}

printPendingPullRequests()
{

  echo "\n${bold_format_purple}Pending PRs${reset_color}"

  #GH_PR_LIST=$(gh pr --user liferay --remote $UPSTREAM | grep $AUTHOR || true)

  GH_PR_LIST=$(gh pr --user liferay --remote $UPSTREAM)

  echo "$GH_PR_LIST"
}

printMyRunningIssues()
{
  echo "\n${bold_format_purple}Pending Issues${reset_color}"

  JIRA_RUNNING_ISSUES=$(jira running)

  echo "$JIRA_RUNNING_ISSUES"

}

AUTHOR=${AUTHOR:="$(git config --global user.name)"}
SINCE=${SINCE:="$(lastworkingday)"}
#SINCE="1 week ago"
UPSTREAM="upstream"

verifyRequirements
#goToRepositoryDir
#updateReporitory
printCommitsAlreadyInUpstream
printPendingPullRequests
printMyRunningIssues
#goBackToTheLastDir
