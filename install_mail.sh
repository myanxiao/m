#!/bin/bash
set -e

echo "✅ 开始下载文件..."

# 使用 raw.githubusercontent.com 下载原始文件
RAW_URL_BASE="https://raw.githubusercontent.com/myanxiao/m/main"

wget -q "$RAW_URL_BASE/limit.sh" -O limit.sh
wget -q "$RAW_URL_BASE/mailbendi.sh" -O mailbendi.sh
wget -q "$RAW_URL_BASE/OneMail_amd64" -O OneMail_amd64
wget -q "$RAW_URL_BASE/OneMail_arm64" -O OneMail_arm64

echo "✅ 下载完成，开始初始化系统..."
bash <(wget --no-check-certificate -qO- "$RAW_URL_BASE/LinuxInit.sh")

# 安装 dos2unix（如果没有）
if ! command -v dos2unix >/dev/null 2>&1; then
    echo "🔄 安装 dos2unix..."
    apt update && apt install -y dos2unix
fi

# 强制转换所有脚本换行符为 LF
echo "🔄 强制转换脚本换行符为 Unix 格式..."
for f in mailbendi.sh limit.sh; do
    # 再次确保 LF
    sed -i 's/\r$//' "$f"
done

# 添加执行权限
chmod +x mailbendi.sh
chmod +x limit.sh 
chmod +x OneMail_amd64
chmod +x OneMail_arm64

# 执行脚本
echo "✅ 开始运行 mailbendi.sh..."
bash mailbendi.sh

echo "✅ 开始运行 limit.sh..."
bash limit.sh

echo "🎉 所有脚本执行完成"
