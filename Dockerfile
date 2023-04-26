
#根据PHP的版本选择抖音云语言基础镜像
FROM public-cn-beijing.cr.volces.com/public/php:8.2-fpm

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

EXPOSE 8000
