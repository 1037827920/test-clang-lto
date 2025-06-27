#!/bin/bash

OUTPUT_FILE="sysbench_tps_report.txt"

# 清空或创建输出文件
> "$OUTPUT_FILE"

# 遍历当前目录下的所有.log文件
for logfile in *.log; do
    # 提取TPS值（格式：transactions: ... (X per sec)）
    tps_value=$(grep "transactions:" "$logfile" | awk -F'[()]' '{print $2}' | awk '{print $1}')

    # 提取测试时间（格式：total time: X.XXXXs）
    total_time=$(grep "total time:" "$logfile" | awk '{print $3}' | sed 's/s//')

    if [ -n "$tps_value" ]; then
        # 写入结果到文件
        echo "文件: $logfile | TPS: $tps_value | 测试时长: ${total_time}秒" >> "$OUTPUT_FILE"
    else
        echo "警告: $logfile 中未找到TPS数据" >> "$OUTPUT_FILE"
    fi
done

echo "结果已保存至: $OUTPUT_FILE"
