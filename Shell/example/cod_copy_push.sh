#!/bin/bash

function getModuledir(){
    for element in `ls $1`
    do  
    	echo -e "\n当前模块目录： $1/$element"
        copy $1 $element
    done
}

function copy(){

    

    new_dir=$1"/TuyaSmart_iOS/Pods/"$2"/"$2

    targer_dir=$1"/"$2

    echo "$new_dir"
    echo "$targer_dir"


    if [  -d $new_dir ];then

       if [  -d $targer_dir ];then

              sudo cp -R   $new_dir  $targer_dir 

       fi

    fi
}


function getdir(){
    for element in `ls $1`
    do  
      echo -e "\n$1/$element"
        push $1"/"$element
    done
}

function push(){
  cd $1

  git add .
  git commit -m "update"
  git push origin
}


read  -p "请输入项目根目录： " doc
echo "目录为: $doc"

# 获取模块文件
getModuledir $doc

# push
getdir $doc
