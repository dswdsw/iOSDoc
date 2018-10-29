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
    version=${array[2]} 
    if [[ ${array[7]} ]]; then
      version=${array[7]}
    fi

    element=(${element//\'})
    version=(${version//\'})

    if [[ "$element" == "$moduleName" ]]; then
      echo $version
      return
    fi

    targer_dir=${filename}"/"${element}
    # echo "$targer_dir"
    
    if [  -d $targer_dir ];then
      sum=`expr ${sum} + 1`
      checkout $targer_dir $version
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

  git checkout $branchName

  git branch  $newbranchName

  git checkout $newbranchName

  git push origin $newbranchName

}

function clone()
{

  doc=$1

  moduleName=$2

  url="ssh://git@code.registry.wgine.com:10023/tuyaIOS/"$moduleName".git"

  cd $doc
  git clone $url
  cd  $moduleName
  git pull
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
  cd $1

  git add .
  result=`git commit -m "update"`
  if [[ $result != *nothing* ]]; then
    echo -e "\n$1/$element"
    echo "update:${element}"
    git push origin
  else
    echo "-------------------no changed----------------------------"
  fi

}

function copy(){

    new_dir=$1"/TuyaSmart_iOS/Pods/"$2"/"$2

    targer_dir=$1"/"$2

    # #判断目录是否修改
    cd  $1"/TuyaSmart_iOS"
    result=`git status -s $new_dir`
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
          newModuleBranchName=$(getBranchName $1"/TuyaSmart_iOS")

          # 修改的模块创建新分支push
          if [[ "$newModuleBranchName" != "$nowModuleBranchName" ]]; then
            read  -p "是否新建模块$2分支${newModuleBranchName} (1:是 0:否) " -n 1 add
            echo -e "\n"

            if [[ $add == "1" ]]; then

              #创建新分支
              checkoutAndNewBranch $targer_dir $podModuleBranchName $newModuleBranchName 
              echo "复制到：$targer_dir"
              sudo cp -R   $new_dir  $targer_dir 

              #修改podfile文件
              podfileUpdate $1 $2

              push $targer_dir
            else
              pushMaster="0"
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
    for element in `ls $1`
    do  
        copy $1 $element
    done
}

#模块全上传后执行
pushMaster="1"

read  -p "请输入项目根目录： " doc

echo -e "start:...\n"

# 获取模块文件
getModuledir $doc

if [[ "$pushMaster" == "1" ]]; then
  push $1"/TuyaSmart_iOS"
fi

echo -e "end...\n"

