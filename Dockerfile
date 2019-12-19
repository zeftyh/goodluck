# This dockerfile uses the centos image
# VERSION 1
# Author: yinliqing
# Date: 2016.02.17
# WeChat: 13521526165
# Tel: 13521526165
# QQ: 76264809

FROM centos

MAINTAINER yinliqing from hub.docker.com(yinliqing_md@sina.com)

# set yum source
# RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
# COPY CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo

# update yum source
# RUN yum clean all
# RUN yum makecache
RUN yum -y update

# install gcc and make
RUN yum -y install gcc make gcc-c++ openssl-devel wget zip unzip

# install apr
RUN mkdir -p /root/docker-src-apache
COPY apr-1.5.2.tar.gz /root/docker-src-apache/apr-1.5.2.tar.gz
RUN cd /root/docker-src-apache && tar -zvxf apr-1.5.2.tar.gz && cd apr-1.5.2 && ./configure --prefix=/usr/local/apr && make && make install

# install apr-util
COPY  apr-util-1.5.4.tar.gz /root/docker-src-apache/apr-util-1.5.4.tar.gz
RUN cd /root/docker-src-apache && tar -zvxf apr-util-1.5.4.tar.gz && cd apr-util-1.5.4 && ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr && make && make install

# install pcre
COPY pcre-8.38.zip /root/docker-src-apache/pcre-8.38.zip
RUN cd /root/docker-src-apache && unzip pcre-8.38.zip && cd pcre-8.38 && ./configure --prefix=/usr/local/pcre && make && make install

# install apache HTTP Server
COPY httpd-2.4.18.tar.gz /root/docker-src-apache/httpd-2.4.18.tar.gz
RUN cd /root/docker-src-apache && tar xvfz httpd-2.4.18.tar.gz && cd httpd-2.4.18 && mv /root/docker-src-apache/apr-1.5.2 /root/docker-src-apache/httpd-2.4.18/srclib/apr && cp -Rf /root/docker-src-apache/apr-util-1.5.4 /root/docker-src-apache/httpd-2.4.18/srclib/apr-util && ./configure --enable-ssl --enable-so --prefix=/usr/local/apache --with-pcre=/usr/local/pcre --with-included-apr  -enable-module=so --enable-so --enable-rewrite && make && make install

EXPOSE 80

# run apache httpd server
COPY start.sh /root/start.sh
RUN chmod 755 /root/start.sh

# define execute command
CMD ["/root/start.sh"]
