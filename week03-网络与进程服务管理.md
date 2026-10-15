## 网络配置

### NAT网络原理图

**NAT桥接模式**

![image-20261015204910560](week03-网络与进程服务管理.assets/image-20261015204910560.png)

绿色：虚拟机为什么能ping通百度

linux虚拟机：ifconfig  （自动分配/固定ip）

vmnet8：本机ipconfig    

无线网卡：本机

#### **补充**

- NAT 模式（对应 vmnet8）：vmnet8 是 NAT 专用虚拟网卡，虚拟机通过它做地址转换上网，虚拟机 IP 必须和 vmnet8 同网段。**默认虚拟机可以访问主机；主机访问虚拟机可能被 Windows 防火墙拦截，需要放开防火墙**。
- 桥接模式：虚拟机 IP（192.168.1.x）的网关、DNS 需要和教室局域网保持一致，否则无法访问外网。**配置正确后，主机和虚拟机可以双向互相访问**。

![image-20261015204927146](week03-网络与进程服务管理.assets/image-20261015204927146.png)

### 网络配置指令

#### 查看网络配置

- 查看windows环境中的VMnet8网络配置

  ipconfig（终端）或 控制面板

- 查看linux的网络配置ifconfig   **if不是ip**

#### ping测试主机之间网络连通性

ping 192.168.1.xxx     ping  www.baidu.com

### 网络配置

1. 自动获取
   说明:登陆后,通过界面的来设置自动获取ip,特点:linux启动后会自动获取IP,缺点是每次自动获取的
   ip地址可能不一样。

2. 指定ip

   说明
   直接修改配置文件来指定IP,并可以连接到外网(程序员推荐)
   编辑 vi /etc/sysconfig/network-scripts/ifcfg-ens33
   要求:将ip地址配置的静态的,比如:ip地址为192.168.200.130

   ![image-20261015211829254](week03-网络与进程服务管理.assets/image-20261015211829254.png)

而且需要在网络编辑器那改网关NAT和子网IP

√ 重启网络服务或者重启系统生效

service network restart , reboot

### 设置主机名和hosts映射

##### 设置主机名

1. 为了方便记忆,可以给linux系统设置主机名,也可以根据需要修改主机名
2. 指令hostname     查看主机名
3. vim   /etc/hostname 修改主机名
4. 修改后,重启生效

#####  设置hosts映射

思考:如何通过 主机名能够找到(比如ping)某个linux系统?

######  windows

**管理员方式运行记事本，然后改，才有效**

在C:\Windows\System32\drivers\etc\hosts文件指定即可
案例:192.168.200.130 hspedu100 （linux-ip  主机名）

然后  ping 主机名

![image-20261015222018178](week03-网络与进程服务管理.assets/image-20261015222018178.png)

######  linux

在/etc/hosts 文件 指定（sudo  -i）
案例:192.168.200.1 ThinkPad-PC

##### 主机名解析过程分析(Hosts、DNS)

###### Hosts是什么

一个文本文件,用来记录IP和Hostname(主机名)的映射关系

######  DNS

1. DNS,就是Domain Name System的缩写,翻译过来就是域名系统
2. 是互联网上作为域名和IP地址相互映射的一个分布式数据库

## 进程管理

## 软件包管理

