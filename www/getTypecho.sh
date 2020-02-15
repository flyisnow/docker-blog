#!/bin/sh
cd `dirname $0`
wget http://typecho.org/downloads/1.1-17.10.30-release.tar.gz
tar zxvf 1.1-17.10.30-release.tar.gz
rm 1.1-17.10.30-release.tar.gz
mv build typecho
chmod -R 777 typecho
