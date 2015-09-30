---
layout: post
title: 内核：Changelist、Features
category: 内核组件
tags: [徐超]
keywords: 内核、传输优化、传输加密
description:
---


## 1.1. Changelist

### 1.1.1 ftcp-3.14.19 分支

#### 1.1.1.1 ftcp-3.14.19-4.x86_64.rpm
 
- 修复了mscc_r算法中的bug，默认是nss=1,即以2G的方式增加窗口，现改为nss=0，拥塞窗口增加的更快些。

- 修改了checkOSconfig中参数获取方式，原来是从/etc/sysctl.conf中获取，现在改为从/proc/sys/net/ipv4下获取。

- 修改了stadmind脚本中的一些代码，将$MODE = 1 to "x$MODE"="x1"，功能性方法没做任何改变。
- 剃除reboot_enable和grubonce功能，这个功能在网络不通的情况下会重启机器，重启后内核切换为2.6.18。

- 安装内核时自动安装kdump工具。

### 1.1.2 mtcp-tos-2.6.37 分支

#### 1.1.2.1 mtcp-tos-2.6.37-49.x86_64.rpm

- 增加应用程序版本查询接口：service ipv4_log status 接口可查看
l 采用第三方日志管理软件，不再保证某一分钟内的日志一定在同一个文件内，日志监
控处理时请注意（已提前沟通、知会过），详阅大包内的readme.txt


## 1.2. 功能特性及配置说明

### 1.2.1. 传输加密功能

> 对协议栈原有的IP报文进行加密（可选），并将加密后IP报文作为payload重新封装TCP/UDP头和IP头，从而把多条TCP/UDP流归并成一条TCP/UDP流进行传输。

#### 1.2.1.1 加密功能配置

##### 服务相关文件

加密服务配置文件：

	/usr/local/stadmin/etc/stadmin.cfg

加密服务管理脚本：
	
	/etc/rc.d/init.d/stadmind

服务配置可执行文件及内核加密实现模块：

	/bin/c_stadmin
	[root@FM-31798 ~]# lsmod | grep st
	c_stcodec              16313  0
  
日志文件：

	/var/log/stadmind.log
	
##### 服务配置及使用

配置文件说明：

	[Mode]
	#route_mode=0: encyption mode; route_mode=1: routing mode
	route_mode=0

	[Role]
	#identity=client: A or AN node; identity=server: C or BN node; idetity=none: not set port
	identity=none//none表示不开启加密功能

	[EncryptMode]
	#encode_port: if the destination port is in the range of A-B, then the segment will be  encrypted
	encode_port=3800-3800    //对目的端口为3800的数据包做加密
	#conn_srcport:  source port setting in fack IP head
	conn_srcport=28288-28288 //伪造的TCP/UDP头的源端口号字段值
	#conn_dstport:  dest port setting in fack IP head
	conn_dstport=30000-30000 //伪造的TCP/UDP头的目的端口号字段值
	#conn_fackip:  fack ip setting in fack IP head
	conn_fackip= //伪造的IP头其源IP地址字段的值

查看服务当前状态：

	service stadmind status
  
	
	destination:
	encode_source_port:
	encode_dst_port:         //机密数据包的端口范围
         3800-3800
	source:
         28288-28288        //伪造tcp头 源端口号的值
	dst:
         30000-30000        //伪造tcp头 目的端口号的值
	passwd: 80 40 20 10  8  4  2  1  1  2  4  8 10 20 40 80
	status: stop            //服务状态，stop表示服务停止 
	src: local              //伪造ip头 的源IP地址，local表示为本机真实IP地址

注意：只有encode_dst_port不为空，并且status的值为running，表示内核加密功能正在工作。

#### 1.2.1.2 开启加密后的tcpdump抓包

	echo 1 > /proc/sys/net/ipv4/tcpdump_sw

之后可以抓到真实的tcp连接通信数据包，否则只能抓到伪造的数据包，也即（如上面的配置）源端口为28288以及目的端口为30000的数据包。

例如在父节点上抓包，echo 0 > /proc/sys/net/ipv4/tcpdump_sw 后抓到的是加密数据包：

	15:07:02.502110 IP 101.100.190.44.28288 > 124.115.20.199.30000: . 187:227(40) ack 934574 win 2363
	15:07:02.502113 IP 101.100.190.44.28288 > 124.115.20.199.30000: . 187:227(40) ack 935974 win 2369
	15:07:02.502116 IP 101.100.190.44.28288 > 124.115.20.199.30000: . 187:227(40) ack 937374 win 2375
	15:07:02.502119 IP 101.100.190.44.28288 > 124.115.20.199.30000: . 187:227(40) ack 938774 win 2380
	15:07:02.502123 IP 101.100.190.44.28288 > 124.115.20.199.30000: . 187:227(40) ack 940174 win 2386

在父节点上抓包，echo 1 > /proc/sys/net/ipv4/tcpdump_sw 后抓到的是解密数据包：

	15:14:34.563531 IP 101.100.190.44.48951 > 124.115.20.199.3800: . ack 920075 win 2432
	15:14:34.563534 IP 101.100.190.44.48951 > 124.115.20.199.3800: . ack 922875 win 2432
	15:14:34.564058 IP 101.100.190.44.48951 > 124.115.20.199.3800: . ack 925675 win 2432
	15:14:34.564108 IP 101.100.190.44.48951 > 124.115.20.199.3800: . ack 928475 win 2432
	15:14:34.564116 IP 101.100.190.44.48951 > 124.115.20.199.3800: . ack 931275 win 2432


### 1.2.2. mp功能


### 1.2.3. 内核默认配置文件