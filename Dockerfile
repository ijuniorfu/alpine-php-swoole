FROM alpine as staging

RUN sed -i -e 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
&& apk update \
&& apk add openssl openssl-dev php7 php7-dev php7-openssl m4 autoconf make gcc g++ linux-headers
ADD swoole-4.4.16.tgz /tmp
WORKDIR /tmp/swoole-4.4.16
RUN phpize  &&  ./configure --enable-openssl &&  make  && make install

FROM alpine

MAINTAINER junior <ijuniorfu@gmail.com>

RUN sed -i -e 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
&& apk update \
&& apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone && apk del tzdata \
&& apk add supervisor && mkdir /etc/supervisor.d \
&& apk add curl php7 php7-pcntl php7-openssl php7-tokenizer php7-pdo_mysql php7-fpm php7-pecl-imagick php7-mysqlnd php7-pecl-redis php7-pecl-amqp php7-opcache php7-curl php7-gd php7-mbstring php7-mysqli php7-json php7-pecl-mcrypt php7-bcmath php7-pecl-igbinary php7-pecl-memcached php7-iconv php7-xml php7-zip php7-dom php7-xmlwriter php7-fileinfo \
&& rm -rf /tmp/* /var/cache/apk/*

COPY --from=staging /usr/lib/php7/modules/swoole.so /usr/lib/php7/modules/swoole.so

RUN touch /etc/php7/conf.d/swoole.ini \
&& echo "extension=swoole.so" >> /etc/php7/conf.d/swoole.ini