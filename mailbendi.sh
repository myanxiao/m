#!/bin/bash

# 检测系统架构
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    VER="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    VER="arm64"
else
    echo "❌ 不支持的架构: $ARCH"
    exit 1
fi

# 初始化目录
rm -rf '/etc/OneMail'
mkdir -p '/etc/OneMail'

# 写启动脚本（参数修正，日志保存到 OneMail.log）
cat > /etc/OneMail/OneMail_Web << 'EOF'
#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
cd "${DIR}"
nohup "${DIR}/OneMail" -bind "0.0.0.0" -port "666" -RootPath "/Mail" -Token "6759" -e 14 >"${DIR}/OneMail.log" 2>&1 &
EOF

# 从 /root 复制对应文件
if [[ -f "/root/OneMail_${VER}" ]]; then
    echo "✅ 检测到 /root/OneMail_${VER}，复制到 /etc/OneMail ..."
    cp "/root/OneMail_${VER}" /etc/OneMail/OneMail
else
    echo "❌ /root 下缺少 OneMail_${VER} 文件，请上传后再运行"
    exit 1
fi

# 权限
chmod -R 755 /etc/OneMail
chown -R root:root /etc/OneMail
chmod +x /etc/OneMail/OneMail
chmod +x /etc/OneMail/OneMail_Web

# 定时任务
sed -i '/OneMail/d' /etc/crontab
while [ -z "$(sed -n '$p' /etc/crontab)" ]; do sed -i '$d' /etc/crontab; done
sed -i '$a\@reboot root bash /etc/OneMail/OneMail_Web\n' /etc/crontab
sed -i '$a\22 2 */1 * * root /bin/sh -c "find /etc/OneMail/OneMail_Eml -mtime +6 -delete"\n\n' /etc/crontab

# 启动
bash /etc/OneMail/OneMail_Web
sleep 1
pgrep -a OneMail || { echo "❌ OneMail 启动失败，查看日志: /etc/OneMail/OneMail.log"; exit 1; }

echo "✅ OneMail 已运行，日志文件: /etc/OneMail/OneMail.log"
