#!/bin/bash

# 1. 定义变量
USERNAME=root # 数据库用户名
PASSWORD="123456" # 数据库密码
IP=127.0.0.1 # 数据库IP地址
PORT=3306 # 数据库端口号
DB_NAME=sbtest # 数据库名称
TABLE_NUMS=10 # 表数量
TABLE_SIZE=100000 # 表大小

# 2. 准备测试数据
sysbench oltp_read_write --db-driver=mysql --mysql-user=$USERNAME \
    --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT \
    --mysql-db=$DB_NAME --tables=$TABLE_NUMS \
    --table-size=$TABLE_SIZE --threads=4 prepare