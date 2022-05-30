#/bin/bash

#一台国内vps 从开始到安装完nginx并设置ssl


#对于腾讯云无法使用ssh登录root的解决方法
# 修改文件 /etc/ssh/sshd_config 中的 PermitRootLogin 后的参数为 Yes，然后使用 systemctl restart sshd


#换源
mv /etc/apt/sources.list /etc/apt/sources.list.default;
echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >>/etc/apt/sources.list;
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list;
echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list;
apt update -y && apt upgrade -y;


#安装 vim
apt install -y vim;
if [ ! -d /etc/vim/vimrc ]; then
    echo -e "set ts=4\n set number" >> /etc/vim/vimrc;
fi
#安装ifconfig
apt install -y net-tools;
#安装lynx
apt install -y lynx;


#安装nginx
apt -y install gcc; 
apt-get -y install libssl-dev;
apt-get -y install  zlib1g zlib1g-dev;
apt-get -y install libpcre3 libpcre3-dev;

cd /home;
if [ ! -d cz ] ; then 
    mkdir cz
fi
mkdir nginx && cd nginx && mkdir sbin conf logs;
cd /root;

#美化autoindex
git clone https://github.com/aperezdc/ngx-fancyindex.git ngx-fancyindex;

#安装nginx并配置文件
wget https://nginx.org/download/nginx-1.20.2.tar.gz && tar -zxvf nginx-1.20.2.tar.gz && rm nginx-1.20.2.tar.gz;
cd nginx-1.20.2;
./configure  --user=www --group=www --prefix=/home/nginx --sbin-path=/home/nginx/sbin/nginx --conf-path=/home/nginx/conf/nginx.conf --error-log-path=/home/nginx/logs/error.log --http-log-path=/home/nginx/logs/access.log --pid-path=/home/nginx/logs/nginx.pid --with-http_ssl_module --with-http_addition_module --add-module=/home/nginx/modules/ngx-fancyindex;

#设置pid
echo "66666" >/home/nginx/logs/nginx.pid;
#可能需要安装
apt install -y make;

make && make install;
cd /home/nginx/sbin/;
groupadd -f www && useradd -g www www && ./nginx;
cd;
ufw enable && ufw allow 80 && ufw allow 443;


#############################################################################

#配置文件
sed -i '116a \t include vhost/*.conf;' /home/nginx/conf/nginx.conf;
mkdir /home/nginx/conf/vhost;
echo -e 'server { \n\t listen 80; \n\t server_name banyun.cz123.top; \n\t root /home/cz; \n\t location ~ { \n\t\t charset utf-8; \n\t\t index index.html NON_EXISTENT_FILE; \n\t\t autoindex on; \n\t\t autoindex_exact_size off; \n\t\t autoindex_localtime on; \n\t } \n }' > /home/nginx/conf/vhost/cz123.top.conf;

########################################################################
#安装ssl
apt install -y snapd;
snap install core;snap refresh core;
#这一步可能会很慢，需要重新开始
snap install --classic certbot;
sudo ln -s /snap/bin/certbot /usr/sbin/certbot;
ln -s /home/nginx/sbin/nginx  /usr/sbin/nginx;
certbot --nginx --nginx-server-root=/home/nginx/conf;







