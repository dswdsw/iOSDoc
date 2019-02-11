
read  -p "请输入目录： " doc
echo "目录为: $doc"
read  -p "请输入分支名： " branchName

cd $doc

git checkout . && git clean -xdf

git checkout $branchName

git branch -u origin/$branchName

git fetch

