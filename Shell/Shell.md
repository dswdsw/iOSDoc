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

### 3.文件复制，移动与删除

1，复制粘贴文件　　cp  [选项]  源文件或目录  目标文件或目录

2，剪切粘贴文件　　mv [选项]  源文件或目录  目标文件或目录

3，删除文件　　　　rm 文件　　　　　　慎用 rm -rf  


#### 一、文件复制命令cp
    命令格式：cp [-adfilprsu] 源文件(source) 目标文件(destination)
              cp [option] source1 source2 source3 ...  directory
    参数说明：
    -a:是指archive的意思，也说是指复制所有的目录
    -d:若源文件为连接文件(link file)，则复制连接文件属性而非文件本身
    -f:强制(force)，若有重复或其它疑问时，不会询问用户，而强制复制
    -i:若目标文件(destination)已存在，在覆盖时会先询问是否真的操作
    -l:建立硬连接(hard link)的连接文件，而非复制文件本身
    -p:与文件的属性一起复制，而非使用默认属性
    -r:递归复制，用于目录的复制操作
    -s:复制成符号连接文件(symbolic link)，即“快捷方式”文件
    -u:若目标文件比源文件旧，更新目标文件
    如将/test1目录下的file1复制到/test3目录，并将文件名改为file2,可输入以下命令：
    cp /test1/file1 /test3/file2
#### 二、文件移动命令mv
    命令格式：mv [-fiv] source destination
    参数说明：
    -f:force，强制直接移动而不询问
    -i:若目标文件(destination)已经存在，就会询问是否覆盖
    -u:若目标文件已经存在，且源文件比较新，才会更新
    如将/test1目录下的file1复制到/test3 目录，并将文件名改为file2,可输入以下命令：
    mv /test1/file1 /test3/file2
#### 三、文件删除命令rm
    命令格式：rm [fir] 文件或目录
    参数说明：
    -f:强制删除
    -i:交互模式，在删除前询问用户是否操作
    -r:递归删除，常用在目录的删除
    如删除/test目录下的file1文件，可以输入以下命令：
    rm -i /test/file1



