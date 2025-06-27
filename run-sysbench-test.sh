#!/bin/bash

# 1. 定义变量
TEST_DURATION=30 # 每次测试持续时间（秒）
THREADS=(1 2 4 8 16 32 64 128) # 测试时使用的线程数
# THREADS=(16 32) # 测试时使用的线程数
REPORT_INTERVAL=10 # 报告间隔（秒）
USERNAME=root # 数据库用户名
PASSWORD="123456" # 数据库密码
IP=127.0.0.1 # 数据库IP地址
PORT=3306 # 数据库端口号
DB_NAME=sbtest # 数据库名称
TABLE_NUMS=10 # 表数量
TABLE_SIZE=100000 # 表大小


# 2. 循环测试不同线程数
for thread in ${THREADS[@]}; do
    echo "Testing with $thread threads..."
    
    sync && echo 3 > /proc/sys/vm/drop_caches
   	sleep 3

    # 预热数据
    sysbench oltp_read_write --db-driver=mysql --mysql-user=$USERNAME \
        --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT \
        --mysql-db=$DB_NAME --tables=$TABLE_NUMS \
        --table-size=$TABLE_SIZE --threads=8 prewarm
    
    sysbench oltp_read_write --db-driver=mysql --mysql-user=$USERNAME \
        --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME \
        --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
        --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
        --percentile=95 --rand-type=uniform --rand-seed=123 \
        run | tee sysbench-${thread}-threads.log
        
    # 每次测完都重启tdsql
    systemctl restart mysqld.service
    rm /var/lib/mysql/binlog.*
done