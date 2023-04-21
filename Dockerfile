
#根据PHP的版本选择抖音云语言基础镜像
FROM public-cn-beijing.cr.volces.com/public/php:8.2-fpm

#安装前置依赖
RUN apt-get clean && apt-get update && apt-get install -y firebird-dev freetds-dev libbz2-dev libc-client-dev libenchant-dev libfreetype6-dev libgmp-dev libicu-dev libjpeg62-turbo-dev libkrb5-dev libldap2-dev libpng-dev libpq-dev libpspell-dev librecode-dev libsnmp-dev libtidy-dev libxml2-dev libxslt1-dev libzip-dev zlib1g-dev
#配置扩展
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \ 
	&& docker-php-ext-configure opcache --enable-opcache \ 
	&& docker-php-ext-configure pdo_dblib --with-libdir=lib/x86_64-linux-gnu
#安装核心扩展
RUN docker-php-ext-install bcmath bz2 calendar dba enchant exif gd gettext gmp imap interbase intl ldap mysqli opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_pgsql pgsql pspell recode shmop snmp soap sockets sysvmsg sysvsem sysvshm tidy wddx xmlrpc xsl zip


# 指定工作目录
WORKDIR /opt/application
# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
COPY . .
USER root

RUN cp /opt/application/conf/nginx.conf /etc/nginx/conf.d/default.conf \
    # 关闭清理环境变量设置
    && sed -i 's/;clear_env = no/clear_env = no/g' /usr/local/etc/php-fpm.d/www.conf \
    # vefaas会占用9000端口，在9090端口启动php-fpm
    && sed -i 's/listen = 9000/listen = 9090/g' /usr/local/etc/php-fpm.d/zz-docker.conf \
    && mkdir -p /run/nginx 

# ThinkPHP框架特殊处理
RUN chmod -R 777 /opt/application/runtime
   
# 生成run.sh
RUN echo '#!/usr/bin/env bash\n\
# 生成vendor\n\
composer install --no-plugins --no-scripts\n\
php-fpm -D\n\
# 关闭后台启动，hold住进程\n\
nginx -g '"'daemon off;'"' ' > /opt/application/run.sh \
&& chmod a+x run.sh
