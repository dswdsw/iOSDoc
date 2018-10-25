#!/bin/bash

function checkout(){

  echo "----------------------------------------------------"
  echo "checkout目录：$1"
  echo "分支名 $2"
  echo ""
  cd $1
  git checkout $2
}

read  -p "请输入目录： " filename

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

    targer_dir=${filename}"/"${element}
    # echo "$targer_dir"
    
    if [  -d $targer_dir ];then
      checkout $targer_dir $version
    fi

  fi



fi

done < $filename'/TuyaSmart_iOS/Podfile'

