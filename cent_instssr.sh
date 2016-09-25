#!/bin/bash
yum install epel-release
yum install python-pip
pip install --upgrade pip
pip install cymysql
yum install git
yum install -y supervisor
cd /root
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cp apiconfig.py userapiconfig.py
cp mysql.json usermysql.json
#可下载配好的usermysql.json文件
scp root@vpn.hwinfo.party:/root/usermysql.json usermysql.json
echo "可下载配好的usermysql.json文件"
cat >user-config.json<<-EOF
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "m",
    "timeout": 120,
    "udp_timeout": 60,
    "method": "aes-256-cfb",
    "protocol": "auth_sha1_compatible",
    "protocol_param": "",
    "obfs": "http_simple_compatible",
    "obfs_param": "",
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}
EOF
chmod +x *.sh
cat > /etc/supervisord.d/shadowsocks.ini<<EOF
[program:shadowsocks]  
command=/usr/bin/python  /root/shadowsocks/server.py 
autorestart=true
user=root
EOF

systemctl restart supervisord
systemctl enable supervisord
supervisorctl reload
supervisorctl restart shadowsocks