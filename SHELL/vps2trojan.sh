#/bin/bash

#ubuntu 20.03 TLS

################################################################################

apt -y update && apt -y upgrade;

#一台国外vps 从开始到安装配置完trojan

#安装 vim
apt install -y vim;
if [ ! -d /etc/vim/vimrc]; then
    echo -e "set ts=4\n set number" >> /etc/vim/vimrc;
fi
#安装ifconfig
apt install -y net-tools;
ifconfig | sed -n '2{s/^.*inet//;s/netma.*$//;s/ //;p}' > ip.txt;

#安装lynx
apt install -y lynx;


################################################################

#更新系统
apt install -y curl;
apt install -y socat;

#Trojan一键代码
bash <(curl -sSL "https://raw.githubusercontent.com/veip007/hj/main/trojan-go.sh");


#前提将伪装域名解析到当前ip地址。