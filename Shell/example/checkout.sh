
read  -p "请输入目录： " doc
echo "目录为: $doc"
read  -p "请输入分支名： " branchName

cd $doc

result=`git checkout $branchName`
 if [[ $result == *$error* ]]; then
    echo -e "\033[43;35m error \033[0m \n" 
 else
 	echo "${result}"
 	git fetch
 fi



read  -p "请输入目录： " doc