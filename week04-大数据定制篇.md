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
mkdir /home/shcode
cd /home/shcode
vim hello.sh
sh hello.sh
```



##### 脚本的常用执行方式

√ 方式1(输入脚本的绝对路径或相对路径)
说明:首先要赋予helloworld.sh脚本的+x权限,再执行脚本（chmod）
√ 方式2(sh  脚本名)
说明:不用赋予脚本+x权限,直接执行即可。

#### shell变量

#####  Shell变量介绍

   1.Linux Shell中的变量分为,系统变量和用户自定义变量。

2. 系统变量:‘$HOME'、'$PWD'、$SHELL、$USER等等,比如:echo $HOME 等等 ..
3. 显示当前shell中所有变量:set

#####  shell变量的定义

###### 基本语法

1. 定义变量:变量=值

2. 撤销变量:unset 变量
3. 声明静态变量:readonly变量,注意:不能unset

###### 快速入门

案例1:定义变量A
案例2:撤销变量A
案例3:声明静态的变量B=2,不能unset
案例4:可把变量提升为全局环境变量,可供其他shell程序使用

###### 定义变量的规则

1. 变量名称可以由字母、数字和下划线组成,但是不能以数字开头。5A=200(x)
2. 等号两侧不能有空格
3. 变量名称一般习惯为大写

###### 将命令的返回值赋给变量

1. A=date 反引号,运行里面的命令,并把结果返回给变量A
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