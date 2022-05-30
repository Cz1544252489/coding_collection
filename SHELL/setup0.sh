#!/bin/sh

#clementine
sudo add-apt-repository ppa:me-davidsansome/clementine
sudo apt-get update
sudo sudo apt-get install clementine

#视频播放器
sudo add-apt-repository ppa:mc3man/mpv-tests
sudo apt-get update
sudo sudo apt-get install mpv

sudo apt-add-repository ppa:rvm/smplayer
sudo apt-get update
sudo apt-get install smplayer smplayer-skins smplayer-themes

#vim and gvim
sudo apt install vim
sudo apt install gvim


#壁纸软件
sudo add-apt-repository ppa:wallch/wallch-4.0
sudo apt-get update
sudo apt-get install wallch

#Connect VPN
sudo apt-get -y install network-manager-openvpn network-manager-openvpn-gnome resolvconf


#wine then sougou,ps6,qq,wechat,wps-office,baidudisk
echo '看硬盘 陈卓0.o下: ubuntu部分软件安装包/wine_db文件夹，并进入。'
echo '使用安装代码： '
echo 'sudo dpkg -i *.deb'
cd /media/zn/陈卓0.o/wine_deb/
sudo apt-get install -f -y ./ukylin-wine_70.6.3.25_amd64.deb
sudo apt-get install -f -y ./sogoupinyin_2.4.0.3469_amd64.deb
sudo apt-get install -f -y ./ukylin-ps6_1.0_amd64.deb
sudo apt-get install -f -y ./ukylin-qq_1.0_amd64.deb
sudo apt-get install -f -y ./ukylin-wechat_3.0.0_amd64.deb
sudo apt-get install -f -y ./wps-office_11.1.0.10702_amd64.deb
sudo apt-get install -f -y ./baidunetdisk_3.5.0_amd64.deb

# MATLAB
echo '看硬盘 陈卓0.o下: ubuntu部分软件安装包/MATLAB文件夹，并进入。'
echo '或者使用MathWorks公司的正版安装'


# onedrive
sudo apt-get install onedrive

# git
sudo apt install git

# VS code
echo '避免使用snap中的vs code因为其无法输入中文'
echo '看硬盘 陈卓0.o下: ubuntu部分软件安装包/VS code 文件夹，并进入。'
echo '使用安装代码： '
echo 'sudo dpkg -i code_1.63.2-1639562499_amd64.deb'

# Discord
sudo snap install discord

# Spotify
sudo snap install spotify

# gcc

