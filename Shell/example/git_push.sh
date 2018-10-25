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

read  -p "请输入目录： " doc
echo "目录为: $doc"

read  -p "是否遍历： " -n 1 list
echo -e "\n"

if [[ $list == "0" ]]; then

    echo "push 当前文件"
	push $doc

else
	echo "push 当前文件下子文件"
    getdir $doc
fi









