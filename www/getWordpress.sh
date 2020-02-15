#!/bin/sh
wget https://downloads.wordpress.org/release/zh_CN/wordpress-5.3.2.zip
unzip wordpress-5.3.2.zip
mkdir -p wordpress/wp-content/tmp
chmod -R 777 wordpress
