---
layout: post
title: 内核：Changelist及使用说明
category: 内核组件
tags: [徐超]
keywords: 内核组件、changelist
description:
---

## 1 内核使用说明

- ftcp-3.14.19：解决中间一公里传输优化问题,包括 mp功能(双边优化)、大丢包率环境下的传输优化；解决网卡多队列问题、解决中断不均衡问题；可用于除mtop项目LB服务以外的所有其他服务运行环境内核；已发布最新内核版本ftcp-3.14.19-10。

- mtcp-tos-2.6.37：主要解决最后一公里无线传输优化的问题；用于mtop项目LB服务的运行环境内核；已发布最新内核版本mtcp-tos-2.6.37-52。

## 2 ftcp-3.14.19 分支

### 2.1 ftcp-3.14.19-10.x86_64.rpm（最新）-- [安装包](http://172.16.1.131/kernel-hub/ftcp-3.14.19_update_v10.tar.gz)

- 更新网卡MAC地址绑定脚本，修复一些BUG。

- 修复一些内核BUG，这些BUG可能造成系统挂机。

- 新增ipv4\_log模块，默认关闭。

- 新增内核ip绑定功能，需要用户态配合。

- 新增针对大丢包率环境进行优化，避免卡死，默认关闭。


### 2.2 ftcp-3.14.19-4.x86_64.rpm
 
- 修复了mscc\_r算法中的bug，默认是nss=1,即以2G的方式增加窗口，现改为nss=0，拥塞窗口增加的更快些。

- 修改了checkOSconfig中参数获取方式，原来是从/etc/sysctl.conf中获取，现在改为从/proc/sys/net/ipv4下获取。

- 修改了stadmind脚本中的一些代码，将$MODE = 1 to "x$MODE"="x1"，功能性方法没做任何改变。
- 剃除reboot\_enable和grubonce功能，这个功能在网络不通的情况下会重启机器，重启后内核切换为2.6.18。

- 安装内核时自动安装kdump工具。

## 3 mtcp-tos-2.6.37 分支

### 3.1 mtcp-tos-2.6.37-52.x86_64.rpm（最新） -- [安装包](http://172.16.1.131/kernel-hub/tos_kernel_update_v52.tar.gz)

- 安装脚本：

	安装新内核前，自动卸载其他版本内核（2.6.32、2.6.37、3.14.19）。
	
	“-f”选项，安装有冲突内核时强制安装mtcp-tos-2.6.37-52。

	“-e”选项，用于移除内核，包含冲突版本的内核（2.6.32、2.6.37、3.14.19）。

	增加了“-n”选项，不覆盖原来的sysctl.conf。

	增加了“-r N”选项（N为整数），可在安装成功后按所设定的时间N分钟后重启。

	执行安装脚本后返回值，用于OMS下放脚本来判断安装是否成功执行。

	将IP加入内网校验程序user_in

- selinux enforcing出现MAC地址与相同局域网内的MAC冲突，开机不能启动的问题，安装默认禁用 selinux。

- tos.sysconf配置错误，现已修改。

- 在进入tcp\_enter\_loss后tcp\_cwnd改为动态可设置值，默认为不设置(tcp\_enter\_loss参数控制)。如果tcp\_enter\_loss参数不配或值为0，tcp\_cwnd就用内核默认的值。tcp\_enter\_loss参数值有效范围1~15，设置大于15时，tcp\_cwnd数值取15，即tcp\_cwnd=15。

- 通过nf\_conntrack.conf文件将默认值修改为nf\_conntrack\_max=3145728，nf\_conntrack\_buckets=393216。只有在加载模块（modprobe nf\_conntrack）后自动生效。

- 参数somaxconn原来可设置负数等无效值，现已修改。


### 3.2 mtcp-tos-2.6.37-49.x86_64.rpm

- 增加应用程序版本查询接口：service ipv4_log status 接口可查看
l 采用第三方日志管理软件，不再保证某一分钟内的日志一定在同一个文件内，日志监
控处理时请注意（已提前沟通、知会过），详阅大包内的readme.txt
