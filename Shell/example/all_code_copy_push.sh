#!/bin/bash

# 获取分支名
function getBranchName()
{
  cd  $1

  result=`git branch | grep '^*' `

  result=(${result//\*})

  echo $result
}

# 获取pod中模块分支名
function getPodModuleBranchName(){
   
  doc=$1

  moduleName=$2

  while read line
  do
  # 获取pod
  if [[ $line == pod* ]]
  then

   array=(${line//,/ })  

   if [[ ${#array[@]}==3 ]]; then
    element=${array[1]} 
    version=${array[7]}
    element=(${element//\'})
    version=(${version//\'})

    if [[ "$element" == "$moduleName" ]]; then
      echo $version
      return
    fi
   fi
  fi
  done < $doc'/TuyaSmart_iOS/Podfile'

}

# 拉取模块在pod里的分支，
function checkoutAndNewBranch(){
  
  doc=$1

  branchName=$2

  newbranchName=$3

  cd $doc

  echo "当前目录:$doc"

  result=`git tag | grep  $branchName`
  if [[ -z "$result" ]]; then
   #不是tag
     
    git checkout . 

    git fetch

    git checkout $branchName

    git fetch

    if [[ "$branchName" == "$newbranchName" ]]; then
      return
    fi

    git branch  $newbranchName

    git checkout $newbranchName

    git pull origin

    git push origin $newbranchName

   else
   #是tag
    git checkout -b $newbranchName $branchName

    git push origin $newbranchName
   
  fi

}

function clone()
{

  doc=$1

  moduleName=$2

  url="ssh://git@code.registry.wgine.com:10023/tuyaIOS/"$moduleName".git"

  cd $doc
  git clone $url
  cd  $moduleName
  git pull origin
}

function podfileUpdate(){

  doc=$1

  moduleName=$2

  while read line
  do
  # 获取pod
  if [[ $line == pod* ]]
  then

   array=(${line//,/ })  

   if [[ ${#array[@]}==3 ]]; then
    element=${array[1]} 
    version=${array[2]} 
    if [[ ${array[7]} ]]; then
      version=${array[7]}
    fi

    element=(${element//\'})
    version=(${version//\'})

    if [[ "$element" == "$moduleName" ]]; then

      newModuleBranchName=$(getBranchName $1"/TuyaSmart_iOS")
      podNew="pod '${moduleName}', :git => 'https://code.registry.wgine.com/tuyaIOS/${moduleName}', :branch => '${newModuleBranchName}'"

      line=${line//\//\\}
      podNew=${podNew//\//\\\/}

      sed -in-place -e "s/$line/$podNew/"  $doc'/TuyaSmart_iOS/Podfile'
      rm -f $doc'/TuyaSmart_iOS/Podfilen-place'
      
      return
    fi
   fi
  fi
  done < $doc'/TuyaSmart_iOS/Podfile'
}

function push(){

  doc=$1
  
  newModuleBranchName=$(getBranchName $doc)

  moduleName=${doc##*/}

  cd $doc

  echo "当前路径：$doc"

  result=`git status -s $doc`
  if [[ -z "$result" ]]; then
      return
  fi

  read  -p "$moduleName->($newModuleBranchName)的更新日志： " log

  git add .
  git commit -m "${log}"

  #todo 代码冲突处理
  git pull origin 

  git push origin 

  
  return

}

function copy(){

    new_dir=$1"/TuyaSmart_iOS/Pods/"$2"/"$2

    targer_dir=$1"/"$2

    # #判断目录是否新建
    result=$(getPodModuleBranchName $1 $2)
    if [[ -z "$result" ]]; then
      return
    fi


    #未拉取,clone修改的对应模块
    if [[ -d $new_dir ]]; then
      if [[ ! -d $targer_dir ]]; then
       clone $1 $2
      fi
    fi


    if [  -d $new_dir ];then
       if [  -d $targer_dir ];then
          
          podModuleBranchName=$(getPodModuleBranchName $1 $2)
          nowModuleBranchName=$(getBranchName $targer_dir)

          # 修改的模块创建新分支push
          if [[ "$podModuleBranchName" != "$nowModuleBranchName" ]]; then
            read  -p "是否切换模块$2分支${newModuleBranchName} (1:是 0:否) " -n 1 add

            if [[ $add == "1" ]]; then

              #创建新分支
              checkoutAndNewBranch $targer_dir $podModuleBranchName $podModuleBranchName 
              echo "复制到：$targer_dir"
              sudo cp -R   $new_dir  $targer_dir 

              #修改podfile文件
              podfileUpdate $1 $2

              push $targer_dir
            else
              pushMaster="1"
              return 
            fi
          else
            echo "复制到：$targer_dir"
            sudo cp -R   $new_dir  $targer_dir 

            push $targer_dir


          fi
       fi

    fi
}


function getModuledir(){
    for element in `ls $1"/TuyaSmart_iOS/Pods"`
    do  
        copy $1 $element
    done
}

#模块全上传后执行
pushMaster="1"

read  -p "请输入项目根目录： " rootPath

echo -e "start:..."

# 获取模块文件
getModuledir $rootPath

echo -e "end..."

read  -p "执行完成......." end

