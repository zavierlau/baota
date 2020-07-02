FROM tutum/centos:centos7
MAINTAINER AN,http://boke.anderd.com
EXPOSE 22 21 20 80 888 8888 3306
RUN yum install -y wget && wget -O install.sh http://v.anderd.com/install.sh && sh install.sh
COPY run.sh /run.sh
RUN chmod 777 /run.sh
