#!/bin/bash

#
# This script updates the branch name to 'main'
#
# Source: https://github.com/evertramos/nginx-proxy-automation
#

# Get the script name and its real file path
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME="${0##*/}"
CURRENT_PATH=$(pwd)

# Go to script path if not there
cd "${SCRIPT_PATH}/../"

# Check branch name
BRANCH_NAME="$(git symbolic-ref HEAD 2>/dev/null | awk -F'/' '{print $3}')"
if [[ -z ${BRANCH_NAME} ]]; then
  echo "[ERROR] No branch was found at ${SCRIPT_PATH}."
fi

if [[ "${BRANCH_NAME}" == "master" ]]; then
  echo "Your local branch 'master' will be renamed to 'main'"
  git branch -m master main
  git fetch origin
  git branch -u origin/main main
  git remote set-head origin -a
fi

if [[ "${BRANCH_NAME}" == "main" ]]; then
  echo "Your local branch is already renamed to 'main'"
fi

if [[ ! "${SCRIPT_PATH}" == "${CURRENT_PATH}" ]]; then
  cd - 1>/dev/null 2>/dev/null
fi

exit 0

