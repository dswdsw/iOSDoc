#!/bin/bash

RED_COLOR='\033[31m'

RESET='\033[0m'


# 获取pod中模块分支名
function getPodModuleBranchName() {

  doc=$1

  moduleName=$2

  while read line; do
    # 获取pod
    if [[ $line == pod* ]]; then

      array=(${line//,/ })

      if [[ ${#array[@]}==3 ]]; then
        element=${array[1]}
        version=${array[2]}
        if [[ ${array[7]} ]]; then
          version=${array[7]}
        fi

        element=(${element//\'/})
        version=(${version//\'/})

        if [[ "$element" == "$moduleName" ]]; then
          echo $version
          return
        fi
      fi
    fi
  done <$doc'/Podfile'

}

function getModuledir() {
  for element in $(ls $1"/Pods"); do
    copy $1 $element
  done
}

# 获取分支名
function getBranchName() {
  cd $1

  result=$(git branch | grep '^*')
  result=(${result//\*/})

  echo $result

}

function copy() {

  podModuleBranchName=$(getPodModuleBranchName $1 $2)

   if [[ "$podModuleBranchName" == "$projectBranchName" ]]; then
      echo -e "$2:$podModuleBranchName"
   fi 
  


}

rootPath=$1

#主工程分支名
projectBranchName=$(getBranchName $rootPath)

# 获取模块文件
getModuledir $rootPath

