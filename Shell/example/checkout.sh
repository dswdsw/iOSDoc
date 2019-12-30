#!/bin/bash

RED_COLOR='\033[31m'

RESET='\033[0m'

#配置密码
pc_password="dswdsw"


read  -p "请输入目录： " doc
echo "目录为: $doc"
read  -p "请输入分支名： " branchName

cd $doc

echo $pc_password | sudo -S git checkout . && git clean -xdf

echo $pc_password | sudo -S git checkout $branchName

echo $pc_password | sudo -S git branch -u origin/$branchName

echo $pc_password | sudo -S git fetch origin $branchName

echo -e  "${RED_COLOR}=== done ===${RESET}"

