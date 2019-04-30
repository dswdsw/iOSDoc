read  -p "请输入目录： " doc
echo "目录为: $doc"

cd $doc

read  -p "请输入原来分支名： " branchName

git checkout . && git clean -xdf

git checkout $branchName

git branch -u origin/$branchName

git fetch origin  $branchName

read  -p "请输入新建分支名： " newbranchName

git checkout -b $newbranchName

git push origin $newbranchName

git branch -u origin/$newbranchName