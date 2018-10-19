# Git SSH
## https 和 SSH 的区别：
### https
1.可以随意克隆github上的项目

2.在push的时候是需要验证用户名和密码

### ssh
1.必须是要克隆的项目的拥有者或管理员，且需要先添加 SSH key

2.在push的时候，是不需要输入用户名的，如果配置SSH key的时候设置了密码，则需要输入密码的，否则直接是不需要输入密码的。


## 在 github 上添加 SSH key 的步骤：
### 1、首先需要检查你电脑是否已经有 SSH key 
运行 git Bash 客户端，输入如下代码：

```
$ cd ~/.ssh
$ ls
```

这两个命令就是检查是否已经存在 id_rsa.pub 或 id_dsa.pub 文件，如果文件已经存在，那么你可以跳过步骤2，直接进入步骤3。

### 2、创建一个 SSH key 

```
$ ssh-keygen -t rsa -C "your_email@example.com"

代码参数含义：
-t 指定密钥类型，默认是 rsa ，可以省略。
-C 设置注释文字，比如邮箱。
-f 指定密钥文件存储文件名。

```

自定义的名字需要执行

```
ssh-add ~/.ssh/ 你的名字 
```
 
接着又会提示你输入两次密码（该密码是你push文件的时候要输入的密码，而不是github管理者的密码），也可以不输入密码，直接按回车


### 3、添加你的 SSH key 到 github上面去
1、拷贝 id_rsa.pub 文件的内容 到 git ssh key 中

 

