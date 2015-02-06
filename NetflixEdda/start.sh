#!/bin/bash
set -e

if [ "${AWS_ACCESS_KEY_ID}" == "" ]; then
  echo "AWS_ACCESS_KEY_ID is not passed. Please set it as dockerrun -e AWS_ACCESS_KEY_ID=<...key...>"
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" == "" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not passed. Please set it as dockerrun -e AWS_SECRET_ACCESS_KEY=<...secret_key_id...>"
  exit 1
fi

if [ "${host}" == "" ]; then
  echo "Host or EC2 name is not passed. Please set it as dockerrun -e host=test@ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com"
  host="ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com"
fi

echo "edda.aws.accessKey="$AWS_ACCESS_KEY_ID >> /var/lib/tomcat7/webapps/ROOT/WEB-INF/classes/edda.properties
echo "edda.aws.secretKey="$AWS_SECRET_ACCESS_KEY >> /var/lib/tomcat7/webapps/ROOT/WEB-INF/classes/edda.properties

echo "Adding credentials for Nginx..."
echo $app_username":"$app_psw
echo $app_username":"$app_psw > /etc/nginx/.htpasswd
sed -i "s/eddahost/$host/g" /etc/nginx/sites-available/netflix-edda.conf


openssl genrsa -des3 -passout pass:yourpassword -out server.key 2048
openssl rsa -in server.key -out server.key.insecure -passin pass:yourpassword
mv server.key server.key.secure
mv server.key.insecure server.key

openssl req -new -key server.key -out server.csr -subj "/C=US/ST=CA/L=Los Gatos/O=Global Security/OU=IT OPS/CN=xervmon.com"
openssl x509 -req -days 365  -in server.csr -signkey server.key -out server.crt

cp server.crt /etc/ssl/certs
cp server.key /etc/ssl/private

mkdir -p /var/log/nginx/log
touch /var/log/nginx/log/netflix-edda.access.log
touch /var/log/nginx/log/netflix-edda.error.log
ln -s /etc/nginx/sites-available/netflix-edda.conf /etc/nginx/sites-enabled/netflix-edda.conf
rm /etc/nginx/sites-enabled/default

echo "Starting nginx"
service nginx restart
service mongodb start
export JAVA_HOME=/usr/lib/jvm/java-8-oracle; 
#service tomcat7 start 
#; tail -f /var/log/tomcat7/catalina.out
#bash
