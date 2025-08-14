#!/bin/bash

# 1. 定义变量
TEST_DURATION=10 # 每次测试持续时间（秒）
THREADS=(1 2 4 8 16 32 64 128) # 测试时使用的线程数
THREADS=(128) # 测试时使用的线程数
REPORT_INTERVAL=5 # 报告间隔（秒）
USERNAME=root # 数据库用户名
PASSWORD="123456" # 数据库密码
IP=127.0.0.1 # 数据库IP地址
PORT=3306 # 数据库端口号
DB_NAME=sbtest # 数据库名称
TABLE_NUMS=10 # 表数量
TABLE_SIZE=10000000 # 表大小
SOCKET="/data/mysql/mysql.sock" # 数据库socket路径

# 关闭irqbalance
systemctl stop irqbalance


for thread in ${THREADS[@]}; do
    # 清除缓存
    echo 3 > /proc/sys/vm/drop_caches
    sleep 5

    sysbench oltp_read_write --db-driver=mysql --mysql-user=$USERNAME \
    --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
    --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
    --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
    --percentile=95 --rand-type=uniform \
    run | tee sysbench-${thread}-threads.log
    
    # 重启MySQL服务
    echo 3 > /proc/sys/vm/drop_caches
    systemctl restart mysqld.service
    rm /data/mysql/binlog.*
    # sleep 200
done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_read_write/no-irqbalance
# sleep 200

# for thread in ${THREADS[@]}; do
#     # ./prepare-test-data.sh oltp_read_only
#     # 清除缓存
#     echo 3 > /proc/sys/vm/drop_caches
#     sleep 5

#     sysbench oltp_read_only --db-driver=mysql --mysql-user=$USERNAME \
#     --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
#     --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
#     --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
#     --percentile=95 --rand-type=uniform \
#     run | tee sysbench-${thread}-threads.log
    
#     # 重启MySQL服务
#     # ./clean-test-data.sh oltp_read_only
#     echo 3 > /proc/sys/vm/drop_caches
#     systemctl restart mysqld.service
#     rm /data/mysql/binlog.*
#     # sleep 120
# done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_read_only/no-irqbalance
# sleep 200

# for thread in ${THREADS[@]}; do
#     # ./prepare-test-data.sh oltp_write_only
#     # 清除缓存
#     echo 3 > /proc/sys/vm/drop_caches
#     sleep 5

#     numactl --cpunodebind=1 --membind=1  sysbench oltp_write_only --db-driver=mysql --mysql-user=$USERNAME \
#     --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
#     --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
#     --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
#     --percentile=95 --rand-type=uniform \
#     run | tee sysbench-${thread}-threads.log
    
#     # 重启MySQL服务
#     # ./clean-test-data.sh oltp_write_only
#     echo 3 > /proc/sys/vm/drop_caches
#     systemctl restart mysqld.service
#     rm /data/mysql/binlog.*
#     # sleep 120
# done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_write_only/no-irqbalance
# sleep 200

# for thread in ${THREADS[@]}; do
#     ./prepare-test-data.sh oltp_point_select
#     # 清除缓存
#     echo 3 > /proc/sys/vm/drop_caches
#     sleep 5

#     sysbench oltp_point_select --db-driver=mysql --mysql-user=$USERNAME \
#     --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
#     --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
#     --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
#     --percentile=95 --rand-type=uniform \
#     run | tee sysbench-${thread}-threads.log
    
#     # 重启MySQL服务
#     ./clean-test-data.sh oltp_point_select
#     echo 3 > /proc/sys/vm/drop_caches
#     systemctl restart mysqld.service
#     rm /data/mysql/binlog.*
#     # sleep 120
# done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_point_select/no-irqbalance
# sleep 200

# for thread in ${THREADS[@]}; do
#     ./prepare-test-data.sh oltp_update_index
#     # 清除缓存
#     echo 3 > /proc/sys/vm/drop_caches
#     sleep 5

#     sysbench oltp_update_index --db-driver=mysql --mysql-user=$USERNAME \
#     --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
#     --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
#     --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
#     --percentile=95 --rand-type=uniform \
#     run | tee sysbench-${thread}-threads.log
    
#     # 重启MySQL服务
#     ./clean-test-data.sh oltp_update_index
#     echo 3 > /proc/sys/vm/drop_caches
#     systemctl restart mysqld.service
#     rm /data/mysql/binlog.*
#     # sleep 120
# done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_update_index/no-irqbalance
# sleep 200

# for thread in ${THREADS[@]}; do
#     ./prepare-test-data.sh oltp_update_non_index
#     # 清除缓存
#     echo 3 > /proc/sys/vm/drop_caches
#     sleep 5

#     sysbench oltp_update_non_index --db-driver=mysql --mysql-user=$USERNAME \
#     --mysql-password=$PASSWORD --mysql-host=$IP --mysql-port=$PORT --mysql-db=$DB_NAME --mysql-socket=$SOCKET \
#     --tables=$TABLE_NUMS --table-size=$TABLE_SIZE --threads=$thread \
#     --time=$TEST_DURATION --report-interval=$REPORT_INTERVAL \
#     --percentile=95 --rand-type=uniform \
#     run | tee sysbench-${thread}-threads.log
    
#     # 重启MySQL服务
#     ./clean-test-data.sh oltp_update_non_index
#     echo 3 > /proc/sys/vm/drop_caches
#     systemctl restart mysqld.service
#     rm /data/mysql/binlog.*
#     # sleep 120
# done

# mv sysbench-* /root/test-clang-lto/tkernel-5.4/clang/oltp_update_non_index/no-irqbalance