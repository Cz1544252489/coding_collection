#/bin/bash


################################################################################

apt -y update && apt -y upgrade;

#一台国外vps 从开始到安装配置完nginx,mysql,php

#安装 vim
apt install -y vim;
if [ ! -d /etc/vim/vimrc]; then
    echo -e "set ts=4\n set number" >> /etc/vim/vimrc;
fi
#安装ifconfig
apt install -y net-tools;
#安装lynx
apt install -y lynx;

#################################################################################

#安装nginx前提包
apt -y install gcc libssl-dev zlib1g zlib1g-dev libpcre3 libpcre3-dev; 

cd /home;
if [ ! -d cz ] ; then 
    mkdir cz
fi

mkdir nginx && cd nginx && mkdir sbin conf logs;
cd /root;

#安装nginx并配置文件
wget https://nginx.org/download/nginx-1.20.2.tar.gz && tar -zxvf nginx-1.20.2.tar.gz && rm nginx-1.20.2.tar.gz;
cd nginx-1.20.2;
./configure  --user=www --group=www --prefix=/home/nginx --sbin-path=/home/nginx/sbin/nginx --conf-path=/home/nginx/conf/nginx.conf --error-log-path=/home/nginx/logs/error.log --http-log-path=/home/nginx/logs/access.log --pid-path=/home/nginx/logs/nginx.pid --with-http_ssl_module

#设置pid
echo "66666" >/home/nginx/logs/nginx.pid;
#可能需要安装
apt install -y make;

make && make install;

groupadd -f www && useradd -g www www;

sed -i '2c user www www;' /home/nginx/conf/nginx.conf; #预期改变第2行
sed -i 's/#pid/pid/g' /home/nginx/conf/nginx.conf;  #预期改变第9行
sed -i '/#charset/{s/#//;s/set .*$/set utf-8;/}' /home/nginx/conf/nginx.conf; #预期改变第39行
sed -i '/error.log\;/{s/#//}' /home/nginx/conf/nginx.conf;  #预期改变第5行
sed -i '/main/{s/#//}' /home/nginx/conf/nginx.conf;  #预期改变第21,25,41行
sed -i '/status/{s/#//}' /home/nginx/conf/nginx.conf;  #预期改变第22行
sed -i '/http_user_agent/{s/#//}' /home/nginx/conf/nginx.conf; #预期改变第23行
sed -i '116c \\t include vhost\/\*\.conf' /home/nginx/conf/nginx.conf;  #预期改变第116行

/home/nginx/sbin/nginx;
cd;



#ufw enable && ufw allow 80 && ufw allow 443;

#############################################################################

#安装mariadb 服务器
apt -y install mariadb-server;
#查看是否安装好
mysqladmin --version;
#设置密码
mysqladmin -u root password ***;

#############################################################################

#安装php
cd /root;
wget https://www.php.net/distributions/php-7.4.28.tar.gz;

tar zxvf php-7.4.28.tar.gz;
apt install -y libxml2 && apt -y install libxml2-dev;
apt install -y libsqlite3-dev && apt -y install pkg-config;
apt install -y libcurl4-openssl-dev;
cd php-7.4.28/ && ./configure --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mysqlnd --with-mysqli=mysqlnd;
make && make install;

cd /root;

cp php.ini-development /usr/local/php/php.ini; 
#修改文件
sed -i '798c cgi.fix_pathinfo=0' /usr/local/php/php.ini; 
cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf;
cp sapi/fpm/php-fpm /usr/local/bin;


cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf; 
#修改文件 143行
sed -i 's/NONE\///' /usr/local/etc/php-fpm.conf; 
#或使用  sed -i '143c include=etc/php-fpm.d/*.conf' /usr/local/etc/php-fpm.conf; 


echo -e "server {\n\t listen 80;\n\t server_name sample.xxx;\n\t root /home/cz;\n\t location ~ { \n\t\t index index.php index.html index.htm;\n\t } \n\t location ~* \.php$ { \n\t\t root /home/cz;\n\t\t fastcgi_index\t index.php;\n\t\t fastcgi_pass\t 127.0.0.1:9000;\n\t\t include\t\t fastcgi_params;\n\t\t fastcgi_param\t SCRIPT_FILENAME\t\$document_root\$fastcgi_script_name;\n\t\t fastcgi_param\t SCRIPT_NAME\t\$fastcgi_script_name;\n\t } \n }" > sample.xxx;

/home/nginx/sbin/nginx -s reload && /usr/local/bin/php-fpm;

echo "<?php phpinfo();?>" >> /home/cz/index/php;


