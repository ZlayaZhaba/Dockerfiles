# Netflix Edda container

FROM dockerfile/java:oracle-java8

EXPOSE 8080

RUN apt-get update -y && apt-get install -y \
	wget \
	nginx \
	mongodb-server \
	tomcat7

WORKDIR /root
RUN wget https://github.com/Netflix/edda/releases/download/2.1/edda-2.1.war -P /var/lib/tomcat7/webapps/ && \
	cd /var/lib/tomcat7/webapps/ROOT && \
	rm -f index.html && \
	jar xf ../edda-2.1.war && \
	cd .. && \
	mv edda-2.1.war edda-2.1.war.bak

RUN mkdir -p /usr/share/tomcat7/common/classes
ADD netflix-edda.conf /etc/nginx/sites-available/
ADD start.sh /root/

RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/environment
RUN echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/default/tomcat7
RUN chmod +x /root/start.sh
#ENTRYPOINT ["/root/start.sh"] 
CMD bash /root/start.sh && export JAVA_HOME=/usr/lib/jvm/java-8-oracle; service tomcat7 start; tail -f /var/log/tomcat7/catalina.out
