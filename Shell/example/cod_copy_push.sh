#!/bin/bash

RED_COLOR='\033[31m'
BLUE_COLOR='\033[36m'
PURPLE_COLOR='\033[35m'
RESET='\033[0m'

# 获取分支名
function getBranchName() {
  cd $1

  result=$(git branch | grep '^*')
  result=(${result//\*/})

  echo $result

}

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
  done <$doc'/TuyaSmart_iOS/Podfile'

}

# 拉取模块在pod里的分支，
function checkoutAndNewBranch() {

  doc=$1
  branchName=$2
  newbranchName=$3

  cd $doc

  result=$(git tag | grep $branchName)
  if [[ -z "$result" ]]; then
    #不是tag

    git checkout . && git clean -xdf
    git checkout $branchName
    git branch -u origin/$branchName
    git fetch origin  $branchName

    if [[ "$branchName" == "$newbranchName" ]]; then
      return
    fi

    git checkout -b $newbranchName
    git push origin $newbranchName
    git branch -u origin/$newbranchName

  else
    #是tag
    git checkout -b $newbranchName $branchName

    git push origin $newbranchName

    git branch -u origin/$newbranchName

  fi

}

function clone() {

  doc=$1
  moduleName=$2
  url="https://code.registry.wgine.com/tuyaIOS/"$moduleName".git"

  cd $doc
  git clone $url
  cd $moduleName
  git pull origin
}

function podfileUpdate() {

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

          newModuleBranchName=$(getBranchName $1"/TuyaSmart_iOS")
          podNew="pod '${moduleName}', :git => 'https://code.registry.wgine.com/tuyaIOS/${moduleName}', :branch => '${newModuleBranchName}'"

          line=${line//\//\\\/}
          podNew=${podNew//\//\\\/}

          sed -in-place -e "s/$line/$podNew/" $doc'/TuyaSmart_iOS/Podfile'
          rm -f $doc'/TuyaSmart_iOS/Podfilen-place'

          return
        fi
      fi
    fi
  done <$doc'/TuyaSmart_iOS/Podfile'
}

function push() {

  doc=$1

  newModuleBranchName=$(getBranchName $doc)

  moduleName=${doc##*/}

  cd $doc

  git branch -u origin/$newModuleBranchName

  #是否有修改
  result=$(git status -s $doc)

  #是否有未提交
  result2=$(git cherry -v)

  if [[ -z "$result" && -z "$result2" ]]; then
    return
  fi

  echo -e "${BLUE_COLOR}$moduleName ${RESET} -> ${PURPLE_COLOR} ($newModuleBranchName) ${RESET}的更新日志："
  read -p " " log

  if [ -z "$log" ]; then

    if [[ $result == *View* ]];then

      pool=('UI修改' 'UI细节修改' '模块UI调整' '模块定制UI' '调整UI'  'change UI' 'UI fix' )

      count=${#pool[@]}

      num=$(($RANDOM%$count+1))

      log=${pool[$num]}

    else

      pool=('模块需求开发' '业务逻辑修改' '功能模块开发' '业务修改' 'bug修复' 'fix 一些问题' '功能修改' )

      count=${#pool[@]}

      num=$(($RANDOM%$count+1))

      log=${pool[$num]}

    fi
 
  fi

  git add .
  git commit -m "feat: ${moduleName}->${newModuleBranchName} ${log}"

  #代码冲突会停止操作
  git pull origin  $newModuleBranchName

  git push origin  $newModuleBranchName

  return

}

function copy() {

  new_dir=$1"/TuyaSmart_iOS/Pods/"$2"/"$2

  targer_dir=$1"/"$2

  if [[ ! -d $new_dir ]]; then
    return
  fi

  # #判断目录是否修改
  cd $1"/TuyaSmart_iOS"
  result=$(git status -s $new_dir)
  if [[ -z "$result" ]]; then
    return
  fi

  #未拉取,clone修改的对应模块
  if [[ ! -d $targer_dir ]]; then
    clone $1 $2
  fi

  podModuleBranchName=$(getPodModuleBranchName $1 $2)
  nowModuleBranchName=$(getBranchName $targer_dir)
  newModuleBranchName=$(getBranchName $1"/TuyaSmart_iOS")

  echo -e "${BLUE_COLOR}==== $2 ===============================${RESET}"

  # 修改的模块创建新分支push
  if [[ "$newModuleBranchName" != "$nowModuleBranchName" ]]; then
    read -p "是否切换模块$2分支${newModuleBranchName} (1:是 0:否) " -n 1 add
    echo -e "\n"

    if [ -z "$add" ]; then
      add='1'
    fi

    if [[ $add == "1" ]]; then
      #创建新分支
      checkoutAndNewBranch $targer_dir $podModuleBranchName $newModuleBranchName
    else
      pushMaster="0"
      return
    fi
  fi

  echo "复制到：$targer_dir"
  echo dsw | sudo -S cp -R $new_dir $targer_dir
  echo -e "\n"
  #修改podfile文件
  podfileUpdate $1 $2
  push $targer_dir

}

function getModuledir() {
  for element in $(ls $1"/TuyaSmart_iOS/Pods"); do
    copy $1 $element
  done
}

#模块全上传后执行
pushMaster="1"

read -p "请输入项目根目录： " rootPath

echo -e "${RED_COLOR}======   start...  =================${RESET}"

# 获取模块文件
getModuledir $rootPath

if [[ "$pushMaster" == "1" ]]; then
  push $rootPath"/TuyaSmart_iOS"
fi

echo -e "${RED_COLOR}======   end...  =================${RESET}"

read -p "执行完成......." end
