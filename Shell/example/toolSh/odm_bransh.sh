#!/bin/bash

RED_COLOR='\033[31m'

RESET='\033[0m'

doc=$1

# read  -p "请输入目录： " doc
# echo "目录为: $doc"

cd $doc


result=$(git branch -r | grep '/odm/')

echo -e "$result"

echo -e  "${RED_COLOR}=== done ===${RESET}"

