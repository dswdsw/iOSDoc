# Shell

## 权限设置


```
chmod 777 文件名.sh

```

## Shell语法

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