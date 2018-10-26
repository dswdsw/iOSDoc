#!/bin/bash

function getModuledir(){
    for element in `ls $1`
    do  
        copy $1 $element
    done
}

function copy(){

    new_dir=$1"/TuyaSmart_iOS/Pods/"$2"/"$2

    targer_dir=$1"/"$2

    if [  -d $new_dir ];then

       if [  -d $targer_dir ];then

          echo "复制到：$targer_dir"
          sudo cp -R   $new_dir  $targer_dir 

       fi

    fi
}


function getdir(){
    for element in `ls $1`
    do  
        push $1"/"$element
    done
}

function push(){
  cd $1

  git add .
  result=`git commit -m "update"`
  if [[ $result != *nothing* ]]; then
    echo -e "\n$1/$element"
    echo "${result}"
    git push origin
  else
    echo "-------------------no changed----------------------------"
  fi

}


read  -p "请输入项目根目录： " doc

echo -e "start:...\n"
# 获取模块文件
getModuledir $doc

# push
getdir $doc
