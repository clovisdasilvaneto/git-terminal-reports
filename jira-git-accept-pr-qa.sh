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

  JIRA_RUNNING_ISSUES=$(jira jql 'project = "PROJECT - Banco General Panama" AND Sprint in openSprints() and status in ("Ready for QA", "In QA")   ORDER BY status,priority DESC')

  echo "$JIRA_RUNNING_ISSUES"

}

AUTHOR=${AUTHOR:="$(git config --global user.name)"}
#SINCE="1 week ago"
UPSTREAM="upstream"

verifyRequirements
#goToRepositoryDir
#updateReporitory
printCommitsAlreadyInUpstream
printPendingPullRequests
printMyRunningIssues
#goBackToTheLastDir
