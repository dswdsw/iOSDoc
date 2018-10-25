read  -p "请输入目录： " doc
echo "目录为: $doc"

cd $doc

read  -p "请输入原来分支名： " branchName

git checkout $branchName

read  -p "请输入新建分支名： " newbranchName

git branch  $newbranchName

git checkout $newbranchName

git push origin $newbranchName