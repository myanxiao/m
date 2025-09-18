#!/bin/bash
set -e

echo "✅ 开始下载文件..."

# 下载脚本和二进制文件
wget -q https://raw.githubusercontent.com/myanxiao/m/main/limit.sh -O limit.sh
wget -q https://raw.githubusercontent.com/myanxiao/m/main/mailbendi.sh -O mailbendi.sh
wget -q https://raw.githubusercontent.com/myanxiao/m/main/OneMail_amd64 -O OneMail_amd64
wget -q https://raw.githubusercontent.com/myanxiao/m/main/OneMail_arm64 -O OneMail_arm64

echo "✅ 下载完成，开始初始化系统..."
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/myanxiao/m/main/LinuxInit.sh')

# 自动处理 CRLF
echo "🔄 转换脚本换行格式为 Unix..."
if ! command -v dos2unix >/dev/null 2>&1; then
    apt update && apt install -y dos2unix
fi
dos2unix mailbendi.sh limit.sh || true

# 添加执行权限
chmod +x mailbendi.sh
chmod +x limit.sh 

# 运行脚本
echo "✅ 开始运行 mailbendi.sh..."
bash mailbendi.sh

echo "✅ 开始运行 limit.sh..."
bash limit.sh

echo "🎉 所有脚本执行完成"
