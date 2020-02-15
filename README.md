# docker-blog
A docker-compose configure for how to build my blog by using typecho or wordpress
以下配置修改假设域名为defn.win


## 修改.env文件
```
DOMAIN_NAME=<域名>  #此处改为自己的域名
CF_Key=<cloudflare的APPKEY>
CF_Email=<cloudflare的邮箱账号>
BLOG_TYPE=wordpress  #只能选择wordpress 、typecho
```
## 下载blog程序
运行www目录下的对应脚本```getWordpress.sh```,或者```getTypecho.sh```,下载对应的blog程序

## 修改nginx配置
#### 将文件```nginx/domain.conf```重命名为```nginx/<域名>.conf```,编辑里面的内容，将```<domain_name>```替换为自己的域名
#### 修改文件```nginx/ssl.conf```，将```<domain_name>```替换为自己的域名

## 运行docker-compose
### 在当前目录下运行```docker-compose up -d```
### 进入mysql容器，创建数据库并授权：
```
docker-compose exec mysql bash  #进入容器
#以下在容器中运行
mysql -uroot -p123456  #进入mysql
#在mysql中运行
create database wordpress;   #wordpress为要创建的数据库，可以自定义，记住，后面需要在blog初始化时用到;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;  #授权远程访问
FLUSH PRIVILEGES;  #保存更改
```
## 使用acme.sh创建证书
在cloudflare上配置域名A记录，然后在docker-blog目录下执行
```
docker-compose exec acme.sh  --issue --dns dns_cf -d <domain_name> #此处要改为自己的域名
```
## 重启nginx容器
```
docker-compose restart nginx  
```
## 访问网页，配置数据

## 修改wp-config.php,配置临时目录
找到最后几行，在此处代码下增加配置
```
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
```
修改后内容
```
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
#以下为新增的
define('WP_TEMP_DIR',ABSPATH.'wp-content/tmp');
define("FS_METHOD","direct");
define("FS_CHMOD_DIR",0777);
define("FS_CHMOD_FILE",0777);
```
## 刷新页面，可以正常安装插件 