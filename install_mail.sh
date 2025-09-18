#!/bin/bash

set -e

echo "✅ 开始下载文件..."

# 下载脚本和二进制文件
wget -q https://raw.githubusercontent.com/myanxiao/m/main/limit.sh -O limit.sh
wget -q https://raw.githubusercontent.com/myanxiao/m/main/mailbendi.sh -O mailbendi.sh
wget -q https://raw.githubusercontent.com/myanxiao/m/main/OneMail_amd64 -O OneMail_amd64
wget -q https://raw.githubusercontent.com/myanxiao/m/main/OneMail_arm64 -O OneMail_arm64

echo "✅ 下载完成，开始初始化系统..."

# 执行初始化脚本
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/myanxiao/m/main/LinuxInit.sh')

# 添加执行权限
chmod +x mailbendi.sh
chmod +x limit.sh 

echo "✅ 开始运行 mailbendi.sh..."
bash mailbendi.sh

echo "✅ 开始运行 limit.sh..."
bash limit.sh

echo "🎉 所有脚本执行完成"
