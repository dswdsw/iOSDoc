#!/bin/bash

RED_COLOR='\033[31m'

RESET='\033[0m'

# 获取分支名
function getBranchName() {
  cd $1

  result=$(git branch | grep '^*')
  result=(${result//\*/})

  echo $result

}

getBranchName $1