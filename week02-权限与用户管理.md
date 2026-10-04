

## 查找指令

#### find

![image-20260927152728045](week02-权限与用户管理.assets/image-20260927152728045.png)

##### 应用实例

```bash
#案例1:按文件名:根据名称查找/home目录下的hello.txt文件
find /home -name hello.txt
#案例2:按拥有者:查找/opt目录下,用户名称为nobody的文件
find /opt -user nobody
#案例3:查找整个linux系统下大于200M的文件(+n大于-n小于 n等于,单位有k,M,G)
find / -size +200M
```

**找不到的文件不会显示**

#### locate

locate指令可以快速定位文件路径。locate指令利用事先建立的系统中所有文件名称及路径的locate数据库实现快速定位给定的文件。Locate指令无需遍历整个文件系统,查询速度较快。为了保证查询结果
的准确度,管理员必须定期更新locate时刻

##### 基本语法

locate 搜索文件

##### 特别说明

由于locate指令基于数据库进行查询,所以第一次运行前,必须使用updatedb指令创建locate数据库。

##### 应用实例

```bash
updatedb
locate hello.java#案例1:请使用locate指令快速定位 hello.txt 文件所在目录
#which可以查看某个指令在哪个目录下  which ls
```

#### grep和管道符号 |

grep过滤查找    ,管道符,   |     ,表示将前一个命令的处理结果输出传递给后面的命令处理。

##### 基本语法

grep [选项]  查找内容  源文件

##### 常用选项

-n     显示匹配行及行号。

-i       忽略字母大小写

##### 应用实例

```bash
cat -n /home/hello.txt | grep "yes" #案例1:请在hello.txt文件中,查找“yes"所在行,并且显示行号     （问题：自己写的时候无文件路径）
grep -n "yes" /home/hello.java  #法二
```

![image-20260927160934137](week02-权限与用户管理.assets/image-20260927160934137.png)

## 压缩和解压

#### gzip/gunzip 指令

gzip 用于压缩文件,gunzip用于解压的

##### 基本语法

gzip 文件      (功能描述:压缩文件,只能将文件压缩为 *- gz文件)
gunzip 文件·gz         (功能描述:解压缩文件命令)

##### 应用实例

```bash
#案例1:gzip压缩,将/home下的hello.txt文件进行压缩
gzip /home/hello.txt
#案例2:gunzip解压缩,将/home下的hello.txt.gz文件进行解压缩
gunzip /home/hello.txt.gz
```

![image-20260927215505007](week02-权限与用户管理.assets/image-20260927215505007.png)

#### zip/unzip 指令

zip 用于压缩文件,unzip用于解压的,这个在项目打包发布中很有用的

##### 基本语法

zip   [选项]   XXX.zip 将要压缩的内容  (功能描述:压缩文件和目录的命令)
unzip  [选项]  XXX.zip   (功能描述:解压缩文件)

解压和压缩都是zip

##### zip常用选项

-r:递归压缩,即压缩目录

##### unzip的常用选项

-d  <目录>:指定解压后文件的存放目录

##### 应用实例

![image-20260927224303438](week02-权限与用户管理.assets/image-20260927224303438.png)

```bash
#案例1:将/home下的 所有文件进行压缩成 myhome.zip
zip -r myhome.zip /home/*#(*可有可无但都表示home及其下面的文件夹全部压缩)         别忘记-r
#案例2:将myhome.zip解压到/opt/tmp 目录下
uzip -d   /opt/tmp home/myhome.zip  
```

![image-20260927224216356](week02-权限与用户管理.assets/image-20260927224216356.png)

![image-20260927224240513](week02-权限与用户管理.assets/image-20260927224240513.png)

#### tar指令

tar 指令 是打包指令,最后打包后的文件是.tar.gz的文件。

##### 基本语法

tar[选项]XXX.tar.gz 打包的内容(功能描述:打包目录,压缩后的文件格式.tar.gz)
选项说明

##### 选项

-C    产生.tar打包文件
-v    显示详细信息
-f     指定压缩后的文件名
-z      打包同时压缩
-x      解包.tar文件

##### 应用实例

```bash
#案例1:压缩多个文件,将/home/pig.txt和/home/cat.txt 压缩成 pc.tar.gz
tar -zcvf pc.tar.gz /home/pig.txt /home/cat.txt
#案例2:将/home的文件夹 压缩成 myhome.tar.gz
tar -zcvf myhome.tar.gz /home/
#案例3:将pc.tar.gz 解压到当前目录
tar -zxvf pc.tar.gz
#案例4:将myhome.tar.gz 解压到/opt/tmp2目录下(1) mkdir/opt/tmp2(2)tar-zxvf/home/myhome.tar.gz-C /opt/tmp2
```



## Linux组基本介绍

在linux中的每个用户必须属于一个组,不能独立于组外。在linux中每个文件有所有者、所在组、其它组的概念。

所有者，创建文件的用户
所在组，创建文件的用户所在组
其它组，所在组之外的组
改变用户所在的组

#### 所有者

一般为文件的创建者,谁创建了该文件,就自然的成为该文件的所有者。

##### 查看文件的所有者

指令:Is   -ahl

##### 修改文件所有者

指令:chown  用户名 文件名

##### 应用案例

```bash
#要求:使用root创建一个文件apple.txt,然后将其所有者修改成 tom
touch apple.txt
chown tom apple.txt
```

#### 文件/目录所在组

当某个用户创建了一个文件后,这个文件的所在组就是该用户所在的组。

##### 查看文件/目录所在组

###### 基本指令

Is -ahl

###### 应用实例

使用fox（用户）创造文件，看看文件属于哪个组

```bash
ll
#得到以下
-rw-r--r--. 1 fox monster 0 11月 5 12:50 ok.txt
```



#####  修改文件/目录所在的组

###### 基本指令

chgrp  组名 文件名

######  应用实例

```bash
#使用root用户创建文件 orange.txt,看看当前这个文件属于哪个组,然后将这个文件所在组,修改到fruit组.
groupadd fruit
touch orange.txt
ll
chgrp fruit orange.txt
```

##### 回顾

###### 基本指令

groupadd 组名

###### 应用实例

```bash
#创建一个组,monster
groupadd monster
#创建一个用户 fox，并放入monster组中
useradd -g monster fox
```

#### 其他组

除文件的所有者和所在组的用户外,系统的其它用户都是文件的其它组

#### 改变用户所在组

在添加用户时,可以指定将该用户添加到哪个组中,同样的用root的管理权限可以改变某个用户所在的组。

##### · 改变用户所在组

1. usermod   -g  组名 用户名
2. usermod    -d  目录名 用户名  改变用户登陆的初始目录

**用户有进入新目录的权限**

##### · 应用实例

```bash
#将zwj这个用户从原来所在组,修改到wudang组。
id zwj                      
cat /etc/group |grep wudang   #查找在不在
usermod -g wudang zwj
```



## 权限

Is -|中显示的内容如下:
-rwxrw-r -- 1 root root 1213 Feb 2 09:39 abc

```
rwx：文件所有者对文件拥有的权限 r-root  w-write  x

```



#### 0-9位说明

1. 第0位确定文件类型（d,-,l,c,b）

​       l是链接,相当于windows的快捷方式
​        d是目录,相当于windows的文件夹
​         c是字符设备文件,鼠标,键盘
​          b是块设备,比如硬盘

2. 第1-3位确定所有者(该文件的所有者)拥有该文件的权限。 --- User
3. 第4-6位确定所属组(同用户组的)拥有该文件的权限, --- Group
4. 第7-9位确定其他用户拥有该文件的权限 --- Other

#### rwx权限详解

●rwx作用到文件

1. [r]代表可读(read):可以读取,查看
2.[w]代表可写(write):可以修改,但是不代表可以删除该文件,删除一个文件的前提条件是对该文件所
在的目录有写权限,才能删除该文件.
3.[x]代表可执行(execute):可以被执行

●rwx作用到目录

  1.[r]代表可读(read):可以读取,Is查看目录内容
  2.[w]代表可写(write):可以修改,对目录内创建+删除+重命名目录
3. [x]代表可执行(execute):可以进入该目录

