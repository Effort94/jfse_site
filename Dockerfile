#===========================================================#
#==========================BACKEND==========================#
#===========================================================#
FROM php:7.4-fpm-alpine

RUN apk add --update --no-cache libgd libpng-dev libjpeg-turbo-dev freetype-dev

RUN docker-php-ext-install -j$(nproc) gd

EXPOSE 9002
#===========================================================#
#==========================DEBUGGER=========================#
#===========================================================#
ARG WITH_XDEBUG=false

RUN pecl install xdebug-2.5.5; \
    echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so";  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    docker-php-ext-enable xdebug; \
    echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/php.ini; \
    echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_port=9002" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini;

#===========================================================#
#==========================FRONTEND=========================#
#===========================================================#
FROM node:12.2.0-alpine
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /app/package.json
RUN npm install --silent
RUN npm install @vue/cli@3.7.0 -g

CMD ["npm", "run", "serve"]
