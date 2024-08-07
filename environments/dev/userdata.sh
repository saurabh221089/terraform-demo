#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
export ip=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body><h1>Hello from Webserver running on instance IP: <b>$ip</b></h1></body></html>" > /var/www/html/index.html