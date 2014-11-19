# XDocker
FROM ubuntu:14.04
MAINTAINER Xervmon
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y mysql-server expect git apache2 libapache2-mod-php5

RUN adduser xdocker
ADD start.sh /root/
ADD db_strip.sh /root/
ADD ./config /root/config
RUN chmod +x /root/start.sh
RUN chmod +x /root/db_strip.sh
CMD /root/start.sh
