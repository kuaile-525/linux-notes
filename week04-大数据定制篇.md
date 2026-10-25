高级篇-大数据定制篇

## Shell

Shell是一个命令行解释器,它为用户提供了一个向Linux内核发送请求以便运行程序的界面系统级程序,
用户可以用Shell来启动、挂起、停止甚至是编写一些程序。

#### shell脚本执行方式

##### 脚本格式要求

1. 脚本以#!/bin/bash开头
2. 脚本需要有可执行权限

编写第一个Shell脚本
需求说明:创建一个Shell脚本,输出hello world!

```bash
mkdir /home/shiyi/shcode
cd /home/shiyi/shcode
vim hello.sh    #  写入 #!/bin/bash  echo "hello,world!"
sh hello.sh
```

##### 脚本的常用执行方式

√ 方式1(输入脚本的绝对路径或相对路径   ./hello.sh        ./home/shiyi/shcode/hello.sh)
说明:首先要赋予hello.sh脚本的+x权限,再执行脚本（chmod u+x hello.sh ）
√ 方式2(sh  hello.sh)
说明:不用赋予脚本+x权限,直接执行即可。

#### shell变量

#####  Shell变量介绍

   1.Linux Shell中的变量分为,系统变量和用户自定义变量。

2. 系统变量:\$HOME、\$SHELL、\$USER等等,比如:echo $HOME 等等 ..
3. 显示当前shell中所有变量:set

#####  shell变量的定义

###### 基本语法

1. 定义变量:变量名=值

2. 撤销变量:unset 变量
3. 声明静态变量:readonly变量,注意:不能unset

###### 快速入门

```bash
#!/bin/bash
#案例1:定义变量A并输出
A=100
echo "A=$A"
echo  A=$A
#案例2:撤销变量A
unset A
echo A=$A  #输出空白，但不影响上面的两个输出
#案例3:声明静态的变量B=2,不能unset
readonly B=200
echo B=$B
unset B   #失败
#案例4:可把变量提升为全局环境变量,可供其他shell程序使用
```



###### 定义变量的规则

1. 变量名称可以由字母、数字和下划线组成,但是不能以数字开头。5A=200(x)
2. 等号两侧不能有空格
3. 变量名称一般习惯为大写

###### 将命令的返回值赋给变量

1. A=\` date `(反引号),运行里面的命令,并把结果返回给变量A
2. A=$(date)等价于反引号

#### 设置环境变量

######  基本语法

1. export变量名=变量值   (功能描述:将shell变量输出为环境变量/全局变量)
source 配置文件  (功能描述:让修改后的配置信息立即生效)
echo $变量名    (功能描述:查询环境变量的值)

###### 快速入门

1. 在/etc/profile文件中定义TOMCAT_HOME环境变量
2. 查看环境变量TOMCAT_HOME的值
3. 在另外一个shell程序中使用 TOMCAT_HOME

注意:在输出TOMCAT_HOME 环境变量前,需要让其生效
source /etc/profile

###### shell脚本的多行注释

:<<!   内容 !（内容要与前后的标识分开）

#### 位置参数变量

当我们执行一个shell脚本时,如果希望获取到命令行的参数信息,就可以使用到位置参数变量
比如 :. /shell.sh 100 200,这个就是一个执行shell的命令行,可以在shell 脚本中获取到参数信息

##### 基本语法

\$ n(功能描述:n为数字,\$0代表命令本身,\$1-\$9代表第一到第九个参数,十以上的参数,十以上的参数需要用大括号包含,如\${10})
\$* (功能描述:这个变量代表命令行中所有的参数,\$*把所有的参数看成一个整体)
\$@(功能描述:这个变量也代表命令行中所有的参数,不过\$@把每个参数区分对待)
$#(功能描述:这个变量代表命令行中所有参数的个数)

##### 实例

```markdown
# shell.sh脚本内的内容
#!/bin/bash
echo "1=$1,2=$2，3=$3,4=$4"
echo "所有参数=$*"
echo "$@"
echo "$#"
# 输出
shiyi@ubuntu:~/shcode$ ./shell.sh 100 200
1=100,2=200，3=,4=
所有参数=100 200
100 200
2
```

#### 预定义变量

##### 基本介绍

就是shell设计者事先已经定义好的变量,可以直接在shell脚本中使用

#####  基本语法

$$       (功能描述:当前进程的进程号(PID))
$!         (功能描述:后台运行的最后一个进程的进程号(PID))
$?         (功能描述:最后一次执行的命令的返回状态。如果这个变量的值为0,证明上一个命令正确执行;如果这个变量的值为非0(具体是哪个数,由命令自己来决定),则证明上一个命令执行不正确了。)

##### 应用实例

在一个shell脚本中简单使用一下预定义变量  prevar.sh

```markdown
# prevar.sh
#!/bin/bash
echo "当前进程=$$"
echo "后台进行的最后一个进程=$!"
/home/shiyi/shcode/myshell.sh
echo "后台进行的最后一个进程=$!"
echo "最后一次执行指令的返回状态=$?"
~
# 输出结果
当前进程=2202
后台进行的最后一个进程=
1=,2=，3=,4=
所有参数=

0
后台进行的最后一个进程=
最后一次执行指令的返回状态=0
# myshell.sh
#!/bin/bash

echo "1=$1,2=$2，3=$3,4=$4"
echo "所有参数=$*"
echo "$@"
echo "$#"
```

#### 运算符

##### 基本介绍

学习如何在shell中进行各种运算操作。

##### 基本语法

1. “\$((运算式))”或“$[运算式]”或者expr m+n//expression表达式

2. 注意expr运算符间要有空格

3. \`expr m - n `
4. expr \\*,/,% 乘,除,取余

##### 应用实例

```markdown
# bash
#!/bin/bash
#案例1：计算（2+3）*4的值
#法一
res1=$(((2+3)*4))
echo "res1=$res1"
#法二
res2=$[(2+3)*4]
echo "res2=$res2"
#法三
temp=`expr 2 + 3`
res4=`expr $temp \* 4`
echo "temp=$temp"
echo "res4=$res4"
#求出两参数的和
SUM=$[$1+$2]
echo "sum=$SUM"
~
# 输出
shiyi@ubuntu:~/shcode$ ./oper.sh 20 30
res1=20
res2=20
temp=5
res4=20
sum=50
```

#### 条件判断

判断语句

##### 基本语法

[ condition ] (注意condition前后要有空格)
#非空返回true,可使用$?验证(0为true,>1为false)

##### 应用实例

[ hspEdu ]                 返回true

[ ]                                 返回false

[ condition ] && echo OK II echo notok         条件满足,执行后面的语

##### 判断语句

1)=字符串比较

2)两个整数的比较
-It 小于   -le 小于等于 little equal       -eq等于        -gt大于      ge 大于等于       -ne 不等于

3)按照文件权限进行判断
-r 有读的权限
-w 有写的权限
-x有执行的权限

4)按照文件类型进行判断
-f文件存在并且是一个常规的文件
-e 文件存在
-d 文件在并是一个目录

##### 应用实例

```markdown
#!/bin/bash
# "ok"是否等于"ok"
if [ "ok"="ok" ]     #
then
        echo "equal"
fi
# 23是否大于22
if [ 23 -ge 22 ]
then
        echo "大于"
fi
# /home/shiyi/aaa.txt 是否存在
if [ -f /home/shiyi/aaa.txt ]
then
        echo "存在"
fi
# 为真
if [ hspedu ]  #即使中间什么也没有也需要一个空格
then
        echo "真"
fi
# 输出
shiyi@ubuntu:~/shcode$ sh ifdemo.sh
equal
大于
真
```

