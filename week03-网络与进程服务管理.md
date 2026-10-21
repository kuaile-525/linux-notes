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
   直接修改配置文件来指定IP,并可以连接到外网(程序员推荐)
   编辑 vi /etc/sysconfig/network-scripts/ifcfg-ens33
   
   (域名劫持攻击)
   
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

###### 应用实例:用户在浏览器输入了www.baidu.com

1. 浏览器先检查**浏览器缓存**中有没有该域名解析IP地址,有就先调用IP完成解析;

   如果没有,就检查**DNS解析器缓存**,如果有直接
   返回IP完成解析。这两个缓存,可以理解为 本地解析器缓存

2. 一般来说,当电脑第一次成功访问某一网站后,在一定时间内,浏
   览器或操作系统会缓存他的IP地址(DNS解析记录).如在cmd窗
   口中输入
   ipconfig /displaydns      //DNS域名解析缓存
   ipconfig /flushdns        //手动清理dns缓存

3. 如果**本地解析器缓存**没有找到对应映射,检查系统中**hosts文件**中
     有没有配置对应的域名IP映射,如果有,则完成解析并返回。

4. 如果 本地DNS解析器缓存 和hosts文件 中均没有找到对应的IP,
     则到**域名服务DNS**进行解析域

![image-20261015223406994](week03-网络与进程服务管理.assets/image-20261015223406994.png)

## 进程管理

### 基本介绍

1. 在LINUX中,每个执行的程序都称为一个进程。每一个进程都分配一个ID号(pid,进程号)。
    =>windows => linux

2. 每个进程都可能以两种方式存在的。前台与后台,所谓前台进程就是用户目前的屏幕上可以进行操作的。后台进程则是实际在操作,但由于屏幕上无法看到的进程,通常使用后台方式执行。
3. 一般系统的服务都是以后台进程的方式存在,而且都会常驻在系统中。直到关机才才结束。

### ps指令详解

#### 显示系统执行的进程

![image-20261016211438871](week03-网络与进程服务管理.assets/image-20261016211438871.png)

```bash
 ps -aux |grep xxx |more  #常用
```

![image-20261016211934447](week03-网络与进程服务管理.assets/image-20261016211934447.png)

##### ps详解、

- USER:用户名称
- PID:进程号
- %CPU:进程占用CPU的百分比
- %MEM:进程占用物理内存的百分比
-  VSZ:进程占用的虚拟内存大小(单位:KB)
- RSS:进程占用的物理内存大小(单位:KB)
-  RTT:终端名称,缩写.
- STAT:进程状态,其中S-睡眠,s-表示该进程是会话的先导进程,N-表示进程拥有比普通优先级更低的优先级,R-正在运行,D-短期等待,Z-僵死进程,T-被跟踪或者被停止等等
- STARTED:进程的启动时间
- TIME:CPU时间,即进程使用CPU的总时间
- COMMAND:启动进程所用的命令和参数,如果过长会被截断显示
  所用的命令和参数

##### 父子进程

![image-20261016214057897](week03-网络与进程服务管理.assets/image-20261016214057897.png)

- 要求:以全格式显示当前所有的进程,查看进程的父进程。
- ps-ef是以全格式显示当前所有的进程    -e显示所有进程。-f全格式
- ps -ef|grep xxx

- PPID:父进程ID
- C:CPU用于计算执行优先级的因子。数值越大,表明进程是CPU密集型运算,执行优先级会降低;数值越小,表明进程是I/O密集型运算,执行优先级会提高
-  STIME:进程启动的时间

### 终止进程kill和killall

若是某个进程执行一半需要停止时,或是已消了很大的系统资源时,此时可以考虑停止该进程。使用kill命令来完成此项任务。
● 基本语法
kill  [选项]  进程号           (功能描述:通过进程号杀死/终止进程)
killall 进程名称(功能描述:通过进程名称杀死进程,也支持通配符,这在系统因负载过大而变得很慢
时很有用)

- 常用选项

9:表示强迫进程立即停止

- 最佳实践

```bash
#案例1:踢掉某个非法登录用户kill 进程号
kill 11421
#案例2:终止远程登录服务sshd,在适当时候再次重启sshd服务
kill sshd  xxxx #(进程号)
/bin/systemctl start sshd.service
#案例3:终止多个gedit,演示 killall gedit

#案例4:强制杀掉一个终端
```



```markdown
# 进程管理：kill / killall / pkill

> 环境：Ubuntu Server（VMware NAT，192.168.174.128）
> 内核：uname -r　系统：lsb_release -a
> 教程环境为 CentOS 7，本节内容通用，无差异
```

##### 怎么造出「两个终端」

- **主机开两个 SSH 窗口连同一台机**——一个跑进程，一个杀进程。这是真实运维形态。
- 备选：tmux（`Ctrl+B %` 垂直分屏、`Ctrl+B o` 切换）

##### 练习靶子：用长驻进程代替教程里的 gedit

```bash
# 终端 A
ping baidu.com          # 一直刷屏、光标被占住 = 教程里"gedit 开着"
```

```bash
# 终端 B
pgrep -l ping           # 找 PID，如 3456
kill 3456               # TERM，礼貌退出 → 终端A 显示 Terminated
kill -9 <PID>           # KILL，杀不动才用    显示killed
killall ping            # 按名字全杀
pkill ping              # 同上，支持正则
```

其他可用靶子：`sleep 600`、`tail -f /var/log/syslog`、`top`

##### 三种信号，别记多

| 信号      | 命令                | 什么时候用                   |
| --------- | ------------------- | ---------------------------- |
| TERM (15) | `kill <pid>`        | **默认先用它**，进程能收尾   |
| KILL (9)  | `kill -9 <pid>`     | 上一招无效才用，进程无法拒绝 |
| 按名字    | `killall` / `pkill` | 懒得查 PID 时                |

**顺序铁律：`pgrep` 确认 → `kill` → 不行才 `-9`**

##### 两个我踩过的坑

1. **杀之前先 `echo $$`**，别把自己的当前 shell 杀了（新手最常犯）。

2. **教程里 `killall sshd` 的案例别跟着做**——我是 SSH 远程连进去的，杀它等于锯自己坐的树枝。要练服务操作用 `sudo systemctl restart ssh`。

   ![image-20261021201144133](week03-网络与进程服务管理.assets/image-20261021201144133.png)

##### 面试能讲的一句

> `-9` 是 KILL 信号，进程无法捕获也无法拒绝，来不及落盘；所以先 `kill`，杀不动再 `-9`，顺序反了可能丢数据。

---



### pstree指令

查看进程树

pstree[选项],可以更加直观的来看进程信息

##### 常用选项

-p:显示进程的PID
-u:显示进程的所属用户

### 服务管理

![image-20261020212918025](week03-网络与进程服务管理.assets/image-20261020212918025.png)

##### 介绍

服务(service)本质就是进程,但是是运行在后台的,通常都会监听某个端口,等待其它程序的请求,比
如(mysqld,sshd 防火墙等),因此我们又称为守护进程,是Linux中非常重要的知识点。【原理图】

##### service管理指令

1. service BR [start | stop | restart | reload | status]
2. 在CentOS7.0后 很多服务不再使用service,而是systemctl(后面专门讲)
3. service指令管理的服务在/etc/init.d 查看

![image-20261020213844586](week03-网络与进程服务管理.assets/image-20261020213844586.png)

######  service管理指令案例

请使用service指令,查看,关闭,启动network[注意:在虚拟系统演示,因为网络连接会关闭]

```bash
service network status #是centos，ubuntu是netplan
# 查看网络服务状态
systemctl status systemd-networkd
# 关闭
sudo systemctl stop systemd-networkd
# 启动
sudo systemctl start systemd-networkd
# 重启网络（推荐）
sudo netplan apply

#在ubuntu黑框里试即可
```

![image-20261020214028622](week03-网络与进程服务管理.assets/image-20261020214028622.png)

##### 查看服务名:

方式1:使用setup      选择系统服务 就可以看到全部，带*，随系统启动而启动。   **只是centos，ubuntu不行**   
方式2:/etc/init.d 看到service指令管理的服务

#####  服务的运行级别(runlevel):

√ Linux系统有7种运行级别(runlevel):**常用的是级别3和5**
运行级别0:系统停机状态,系统默认运行级别不能设为0,否则不能正常启动
运行级别1:单用户工作状态,root权限,用于系统维护,禁止远程登陆
运行级别2:多用户状态(没有NFS),不支持网络
**运行级别3**:完全的多用户状态(有NFS),登陆后进入控制台命令行模式
运行级别4:系统未使用,保留
**运行级别5**:X11控制台,登陆后进入图形GUI模式
运行级别6:系统正常关闭并重启,默认运行级别不能设为6,否则不能正常启动

![image-20261020215520019](week03-网络与进程服务管理.assets/image-20261020215520019.png)

```markdown
# 启动目标：systemd target（运行级别的现代版）

> 环境：Ubuntu Server（VMware NAT，192.168.174.128）

## 一句话理解

老系统（SysV）用「运行级别 runlevel 0–6」决定开机进图形还是命令行；
systemd 时代改用「target」，本质一样，名字变了。

| 老（runlevel）              | 新（target）       | 含义 |
| 2（Debian 系）/ 3（RHEL 系） | multi-user.target | **纯命令行（服务器）** |
| 5                          | graphical.target  | 图形桌面 |
| 0 / 6                      | poweroff.target / reboot.target | 关机 / 重启 |

## 实际用过的命令

```bash
systemctl get-default        # 看当前默认启动目标
# 我的输出：multi-user.target —— 证明这台 Server 没装图形

sudo systemctl set-default multi-user.target    # 设默认进命令行
```

###### 踩坑

1. **教程里 `multi-user.target: analogous to runlevel 2` 是注释不是命令**，
   敲进去报 `command not found`。判断方法：`#` 开头、带冒号解释的都是给人看的。
2. **`echo$$` 少空格**，shell 把它解析成 `echo2414` 这条不存在的命令。
   `echo` 和 `$$` 之间必须有空格：`echo $$` → 输出当前 shell 的 PID。
3. 杀进程前先 `echo $$`，确认要杀的 PID 不是当前 shell。

###### 对照表标注（CentOS 差异）

> 教程环境的 CentOS 查/设运行级别用 `chkconfig`、配置文件 `/etc/inittab`（已废弃）；
> Ubuntu 上没有 chkconfig，统一用 systemctl + target。

###### 面试能讲的一句

> 现在生产环境都用 systemd，开机行为由 default.target 决定；
> 服务器应保持 multi-user.target——不装图形既是省资源，也是缩小攻击面。
```markdown

**两个使用提醒：**

- 里面代码块嵌了 ```` ``` ````，粘贴时注意层级别搞乱（外层文件里直接是 ```bash 块，不用再包一层）。
- 表格里“runlevel 2 = Debian 系命令行”这点正好解释了你截图里的 `analogous to runlevel 2`——教程说 2 不说 3，是因为 CentOS 惯例是 3，Debian/Ubuntu 惯例是 2。**含义都是“多用户命令行”**，别被数字绕晕。
```

##### systemctl 取代chkconfig

```markdown
# 服务管理：systemctl

> 环境：Ubuntu Server（VMware NAT，192.168.174.128）
> systemd 通用：CentOS 7 / Ubuntu 16.04+ 都用 systemctl 管服务
> 教程环境的 CentOS 老工具 chkconfig 只需知道：查自启 chkconfig --list、
> 设自启 chkconfig 服务名 on/off，对应下面的 enable/disable，其余不记

## systemctl 管的是什么

- 服务单元文件在 /lib/systemd/system/ 和 /etc/systemd/system/（不再是 /etc/init.d）
- 服务有两套独立状态，别混：
  - **运行状态**：running / stopped / failed —— 现在活没活着
  - **自启状态**：enabled / disabled —— 开机要不要拉起来

## 核心命令（都在 Server 上实际跑过，对象用 ssh）

```bash
# 看状态
systemctl status ssh          # active (running) + enabled 才算正常

# 运行控制
sudo systemctl start ssh      # 启动
sudo systemctl stop ssh       # 停止
sudo systemctl restart ssh    # 重启（改完配置用这个）
sudo systemctl reload ssh     # 只重读配置，不断连接（支持的才有）

# 自启控制
systemctl is-enabled ssh              # 只查自启状态
sudo systemctl enable ssh             # 设开机自启（现在不启动）
sudo systemctl enable --now ssh       # 自启 + 立刻启动，一步到位
sudo systemctl disable ssh            # 取消开机自启（现在不停）

# 查看所有服务（等价老 chkconfig --list）
systemctl list-unit-files --type=service | grep ssh

## 补充：临时 vs 永久

| 操作 | 生效范围 | 重启后 |
| start / stop | **临时**（现在） | 失效，回到自启状态 |
| enable / disable | **永久**（开机行为） | 保持 |

⇒ 想让改动"现在+以后"都生效：stop/disable 或 start/enable 各来一次，
   或 `enable --now` / `disable --now` 一步到位。
```

###### 三个易混点（我踩过的）

1. **enable ≠ start**。enable 只管"开机拉不拉"，不管现在。
   想一步到位用 `enable --now`；反之 stop 完服务，enable 状态还在。
2. **enable 和 target 无关**。target（multi-user / graphical）管开机进哪种模式，
   enable 管单个服务开机自启，两个维度。
3. **Ubuntu 桌面版的网络服务是 NetworkManager，Server 上没有**（Server 用
   systemd-networkd + netplan）。教程拿 NetworkManager 演示，是因为它装的是桌面版；
   我在 Server 上练，对象换成 ssh。看到 `could not be found` 先想是不是服务不存在。

###### 实验记录

```bash
systemctl status ssh            # → active (running)、enabled
sudo systemctl disable ssh && systemctl is-enabled ssh   # → disabled(取消开机自启，查看开机是否自启)
sudo systemctl enable --now ssh && systemctl is-enabled ssh   # → enabled (设回开机自启 + 顺手立刻启动&&再问一遍状态)
sudo systemctl stop ssh      # 跑完 SSH 窗口还活着（新建ssh连接连不上）
sudo systemctl start ssh   #恢复
```
```bash
ss -tlnp | grep -E ':22|:80'     # 服务器侧：看端口在不在 LISTEN

# 主机侧（Windows PowerShell）：

# Test-NetConnection 192.168.174.128 -Port 22   → True = 通
```

##### 防火墙

~~~markdown
# 防火墙案例（视频用 CentOS firewalld，我的是 Ubuntu → ufw）

```bash
# ① 起点确认：SSH 必须是活的（后面锁门还能开得回来）
systemctl is-active ssh         # → active

# ② 看防火墙现状
sudo ufw status             # → Status: inactive（Server 默认关）

# ③ 关键顺序：先放行 SSH，再开防火墙（反了就把自己锁外面）
sudo ufw allow ssh          # → Rules updated
sudo ufw enable      # 输入 y 回车 → Firewall is active

# ④ 看结果
sudo ufw status             # → 22/tcp ALLOW，Status: active

# ⑤ 服务器侧验证端口在听
ss -tlnp | grep :22         # → 有 0.0.0.0:22 在 LISTEN

> telnet 测端口 → 我的替代：服务器侧 `ss -tlnp`，主机侧   ss -tlnp | grep :22    
> PowerShell `Test-NetConnection <IP> -Port 端口号`  看通没通

## firewalld ↔ ufw 对照（遇到 CentOS 机器时查这张，不用背）

111/tcp为例  开-查看状态-关-查看状态

| 功能   | CentOS（firewalld）                            | Ubuntu（ufw）                  |

| 开端口 | firewall-cmd --permanent --add-port=111/tcp    | sudo ufw allow 111/tcp        |
| 关端口 | firewall-cmd --permanent --remove-port=111/tcp | sudo ufw delete allow 111/tcp |
| 生效   | firewall-cmd --reload（要手动重载）              | **立即生效，不用 reload**       |
| 查端口 | firewall-cmd --query-port=111/tcp              | sudo ufw status               |
~~~

![image-20261021210602125](week03-网络与进程服务管理.assets/image-20261021210602125.png)

> firewalld 加规则要 `--permanent` + `--reload` 两步才生效；**ufw 一条命令立即生效**。
> 这不是 Ubuntu 偷懒——firewalld 的“永久配置和运行配置分离”在运维上是优点（改了不用立刻生效），两种设计各有道理。面试要是聊到防火墙，这一句能体现你用过两边。

### 动态监控进程

##### 介绍:

top与ps命令很相似。它们都用来显示正在执行的进程。Top与ps最大的不同之处,在于top在执行一段时间可以更新正在运行的进程。

##### 基本语法

top[选项]

![image-20261021214543887](week03-网络与进程服务管理.assets/image-20261021214543887.png)



![image-20261021213920888](week03-网络与进程服务管理.assets/image-20261021213920888.png)

交互操作  **区分大小写**

##### 应用实例

案例1.监视特定用户,比如我们监控tom用户
top:输入此命令,按回车键,查看执行的进程。
u:然后输入“u"回车,再输入用户名,即可,

案例2:终止指定的进程
top:输入此命令,按回车键,查看执行的进程。

topk:然后输入“k"回车,再输入要结束的进程ID号

案例3:指定系统状态更新的时间(每隔10秒自动更新):

top -d 10

### 监控网络状态

#### 查看系统网络情况netstat

#####  基本语法

netstat[选项]

#####  选项说明

-an 按一定顺序排列输出
-p 显示哪个进程在调用

**local address 与foreign address**

![image-20261021215519398](week03-网络与进程服务管理.assets/image-20261021215519398.png)

**state**

listen 监听  established 连接   time wait 等待（tom登录后退出登录，8011与22 time wait）

#####  应用案例

请查看服务名为sshd的服务的信息。

```bash
netstat -anp | grep sshd
```

●检测主机连接命令ping:

是一种网络检测检测工具,它主要是用检测远程主机是否正常,或是两部主机间的网线或网卡故障。

如:ping对方ip地址

## 软件包管理

 

