# linux-notes · 网安方向的 Linux 学习与实操记录

> 网络空间安全专业本科在读，从零开始按周推进的 Linux 学习仓库。
> **每条命令都在本机亲手执行过**——笔记记的是"我理解了什么"，不是终端日志。
> 每节末尾固定留一句**「面试能讲的话」**，攒的是讲得出来的东西，不是命令清单。

## 环境

| 项目 | 说明 |
|---|---|
| 服务器 | Ubuntu Server 22.04.5 LTS（VMware，NAT，内核 5.15） |
| 攻击机 | Kali Linux（同 Debian 家族，命令通用） |
| 主教程 | 韩顺平 Linux（CentOS 7 环境，CentOS 7 已 EOL） |

> 因教程是 CentOS 环境，笔记正文**只保留我在 Ubuntu 上实测过的命令**，CentOS 内容压成一行「对照标注」。三系统差异（yum/apt、secure/auth.log、SELinux/AppArmor）整理了对照表，见 week01 §5。

## 学习路线

| 周 | 笔记 | 核心内容 | 安全视角亮点 |
|---|---|---|---|
| 1 | [week01-目录结构与文件操作](week01-目录结构与文件操作.md) | 目录结构、vim、文件操作、重定向、用户与组入门 | `/etc`（运维之魂）/ `/var/log`（SOC 之眼）/ `/tmp`（攻击者落地目录）的攻防意义；SELinux vs AppArmor；GRUB 重置 root 密码 = 物理访问即管理员权限 |
| 2 | [week02-权限与用户管理](week02-权限与用户管理.md) | rwx 与数字法、chmod/chown、sudo、特殊权限、crontab、磁盘挂载 | `/etc/shadow` 字段解读与空密码审计；SUID 提权排查 `find / -perm -4000`；`chage` 密码策略（等保「口令定期更换」的落地命令）；fstab 用 UUID + `mount -a` 验证 |
| 3 | [week03-网络与进程服务管理](week03-网络与进程服务管理.md) | netplan、进程管理、systemctl、ufw、ss、apt | **完整网络改造实战**：桥接静态 → NAT DHCP（含备份与回滚），靶场隔离出校园网；防火墙先放行 SSH 再开墙；`last`/`lastb` 登录审计起点 |
| 4 | [week04-大数据定制篇](week04-大数据定制篇.md) | Shell 脚本：变量、位置参数 `$n/$@/$#`、条件判断、流程控制 | 下一步用这些写 **SSH 暴力破解日志巡检脚本**（`grep "Failed password" /var/log/auth.log` → 攻击源 Top N） |

辅助文档：[01 ubuntu 环境搭建与部署](01%20ubuntu%20环境搭建与部署) ｜ `demos/` 实验演示

## 笔记的统一规则

1. 正文只记 **Ubuntu 上亲手执行过的命令**；没跑过的（如 `scp`）明确标注"只记用法"，不混进"实测"。
2. 纯查询类、输出一眼看明白的不贴输出；需要解读的（权限位、lsblk、fstab）才贴。
3. 需要 root 的命令统一写 `sudo`，不直接切 root——最小权限原则。
4. 每节末尾一句**面试能讲的话**。
5. 动 `/etc` 下的配置、删文件、改网络之前：**先备份 / 先拍快照**，改完立刻验证（week03 的网络改造全程按这个流程走，含回滚方案）。
6. 跨周不重复展开：同一主题只在对应周的深度笔记里展开一次，其余保留指针。

## Roadmap

- [ ] Shell 脚本实战①：SSH 暴力破解排查脚本（`last` / `lastb` / `auth.log` → 攻击源 Top N 报告）
- [ ] `scp` 实操：把 `/var/log/auth.log` 拉到本机做登录审计
- [ ] 日志管理进阶：`logrotate` 与等保「日志留存 ≥ 6 个月」的对应关系

---
*持续更新中 · 操作图均为本人实操截图*
