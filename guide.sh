#!/bin/sh
read -p "please input your domain or sub domain: "  domainName
read -p "please input your Cloudflare App key: "  CF_Key
read -p "please input your Cloudflare account's Email address: "  CF_Email
read -p "please input your Blog Type [wordpress or typecho]: "  Blog_Type
echo "your input:" 
echo "domain_name=" $domainName
echo "CF_Key=" $CF_Key
echo "CF_Email=" $CF_Email
echo "Blog_Type=" $Blog_Type

echo "create config files"
sed "s/\<domain_name\>/$domainName/g" ./nginx/domain.conf.template  > ./nginx/domain.conf
sed "s/\<domain_name\>/$domainName/g" ./nginx/ssl.config.template  > ./nginx/ssl.config
sed -e "s/<domain_name>/$domainName/g" -e "s/<CF_Key>/$CF_Key/g" -e "s/<CF_Email>/$CF_Email/g" -e "s/<Blog_Type>/$Blog_Type/g" ./.env.template >./.env  


echo "download blog "
sh +x ./www/get${Blog_Type^}.sh


echo "create docker bridge"
docker network create fly_bridge
echo "begin docker-compose"
docker-compose up -d

echo "begin get domain ssl"
docker-compose exec acme.sh  --issue --dns dns_cf -d $domainName

echo "begin set mysql"
docker-compose exec mysql mysql -uroot -p123456 -e "create database $Blog_Type;"
docker-compose exec mysql mysql -uroot -p123456 -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;FLUSH PRIVILEGES;"

echo "restart nginx"
docker-compose restart nginx  
