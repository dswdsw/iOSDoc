# Shell

## 权限设置


```
chmod 777 文件名.sh

```

## Shell用法

### 1.输入参数

```
read [选项][变量名]
-p "提示信息"
-t 秒数         
-n 字符数      read 命令只接受指定的字符数，就会执行
-s            隐藏输入的数据

例子
read -t 30 -n 1 -p "请输入用户性别:" sex
echo -e "\n"
echo "性别为$sex"

```

### 2.目录读取

例子

```
#!/bin/bash
function getdir(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
            echo $dir_or_file
        fi  
    done
}
root_dir="/home/test"
getdir $root_dir
```

操作

```
#以下命令均不包含"."，".."目录，以及"."开头的隐藏文件，如需包含，ll 需要加上 -a参数
#当前目录下文件个数，不包含子目录
ll |grep "^-"|wc -l
#当前目录下目录个数，不包含子目录
ll |grep "^d"|wc -l
#当前目录下文件个数，包含子目录
ll -R|grep "^-"|wc -l
#当前目录下目录个数，包含子目录
ll -R|grep "^d"|wc -l`
```




