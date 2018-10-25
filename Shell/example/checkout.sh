
read  -p "请输入目录： " doc
echo "目录为: $doc"

cd $doc

read  -p "请输入分支名： " branchName

git checkout $branchName