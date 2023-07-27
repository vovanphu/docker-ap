# Use the Ubuntu 20.04 base image
FROM ubuntu:20.04

LABEL maintainer="phu.vo@cloudgo.vn"

# Set environment variables to avoid interaction during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

# Update and install necessary packages
RUN apt update && apt -y install software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt install -y \
    nano \
    vim \
    wget \
    curl \
    zip \
    unzip \
    apache2 \
    php7.2 \
    php7.2-fpm \
    libapache2-mod-php7.2 \
    php7.2-common \
    php7.2-sqlite3 \
    php7.2-json \
    php7.2-curl \
    php7.2-intl \
    php7.2-mbstring \
    php7.2-xmlrpc \
    php7.2-mysql \
    php7.2-gd \
    php7.2-xml \
    php7.2-cli \
    php7.2-zip \
    php7.2-soap \
    php7.2-imap \
    php7.2-bcmath \
    php7.2-xdebug

RUN a2enmod rewrite expires proxy_fcgi setenvif
RUN a2enconf php7.2-fpm

# Download, extract, and install ionCube Loader
WORKDIR /tmp
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar -zxvf ioncube_loaders_lin_x86* && \
    cp /tmp/ioncube/ioncube_loader_lin_7.2.so /usr/lib/php/20170718/ioncube_loader_lin_7.2.so

# Clean up package cache and remove unnecessary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose port 80 for Apache2 and port 3306 for MySQL
EXPOSE 80

VOLUME /var/www/html

# Start Apache2 and MySQL services using the CMD instruction
CMD service php7.2-fpm start && service apache2 start && tail -f /var/log/apache2/access.log
