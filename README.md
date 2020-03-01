
#2020-03-01更新
将之前的步骤封装成向导脚本，直接运行```./guide.sh```,根据提示内容正确填写即可。

#以下仅做参考，可以单独使用，新手建议直接运行```guide.sh```脚本。
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
1.下载安装wordpress
```
sh +x ./www/getWordpress.sh  #安装wordpress，并授权所有目录777权限
```
2.下载安装typecho
```
sh +x ./www/getTypecho.sh #安装typecho，并授权所有目录777权限
```
## 修改nginx配置
将文件```nginx/domain.conf```重命名为```nginx/<域名>.conf```,编辑里面的内容，将```<domain_name>```替换为自己的域名
修改文件```nginx/ssl.conf```，将```<domain_name>```替换为自己的域名
## 创建网关
```
docker network create fly_bridge
```
## 运行docker-compose
### 在当前目录下运行```docker-compose up -d```
### 进入mysql容器，创建数据库并授权：
```
docker-compose exec mysql mysql -uroot -p123456  #进入容器mysql

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
# 配置wordpress
## 访问网页，配置数据
打开页面，展现欢迎页面
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/WeChatba7ea32426e80186df10473812458a12.png)
输入必要数据，数据库名为我们在mysql中创建的数据库，其它的按照截图中的填写即可
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/WeChat81a0d818eebb0af06b07035c9a9f0c76.png)
提示开始安装
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/WeChata72f280d2d9bf9f1ce2a76dbdf5a5e6d.png)
然后配置个人信息，输入后点击【安装Wordpress】
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/WeChat6808aa1f3b481b75a77443b7446df29e.png)
安装成功后会进入如下页面
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/WeChat7409aba354bd777d7d3cd22ceff1ab07.png)
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
## 判断是否成功
刷新页面，选择任意一个插件，能够安装成功，表示配置正确；

# 配置typecho
欢迎页面
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/20200215232547.png)
进入配置页面，数据库为之前在mysql容器中创建的名字，密码可以在docker-compose.yml中修改，默认为‘123456’
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/20200215232719.png)
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/20200215232757.png)
提示安装成功，实际可能与截图不一样，因为我这次是选择了已有表的数据库
![](https://raw.githubusercontent.com/flyisnow/hipstr/master/img/20200215233018.png)
安装成功后，可进入控制面板进行文章发布。
开始你的旅途吧！！