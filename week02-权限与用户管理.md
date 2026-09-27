# 9.27

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

