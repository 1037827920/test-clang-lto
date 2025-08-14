import csv

def read_data_from_file(file_path):
    """从文本文件读取数据并返回二维列表"""
    data = []
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            # 去除空白字符并按逗号分割，转换为浮点数
            row = [float(x.strip()) for x in line.strip().split(',')]
            data.append(row)
    return data

def transpose_data(raw_data):
    """将原始数据转置为CSV需要的格式"""
    # 提取并发数列（每行第一个元素）
    concurrency_nums = [row[0] for row in raw_data]

    # 构建表头
    column_headers = ['并发数'] + concurrency_nums
    transposed = [column_headers]
    
    # 动态生成每一列的标题，如 '第一次TpmC', '第二次TpmC', ...
    num_columns = len(raw_data[0])  # 获取列数
    for i in range(1, num_columns):
        transposed.append([f"第{i}次TpmC"] + [row[i] for row in raw_data])
    return transposed

def write_to_csv(data, output_file):
    """将数据写入CSV文件"""
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerows(data)

if __name__ == "__main__":
    # 文件路径配置
    input_file = 'result.txt'
    output_file = 'tps_results.csv'
    
    # 数据处理流程
    raw_data = read_data_from_file(input_file)
    transposed_data = transpose_data(raw_data)
    write_to_csv(transposed_data, output_file)
    
    print(f"CSV文件已生成：{output_file}")