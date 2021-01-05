#!/bin/sh

# build-dep: apt-utils autoconf automake build-essential git libcurl4-openssl-dev
# libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
# dep: libmodsecurity3

NGINX_VERSION=1.14.2

cd $(dirname $0)
cd ..
rm -rf nginx-* nginx_*
apt source nginx=$NGINX_VERSION
cd nginx-$NGINX_VERSION

debian_cflags="$(dpkg-buildflags --get CFLAGS) -fPIC $(dpkg-buildflags --get CPPFLAGS)"
debian_ldflags="$(dpkg-buildflags --get LDFLAGS) -fPIC"

./configure \
    --with-cc-opt="$debian_cflags" \
    --with-ld-opt="$debian_ldflags" \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-debug \
    --with-pcre-jit \
    --with-threads \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --add-dynamic-module=../ModSecurity-nginx 

make -j 8

cp ./objs/ngx_http_modsecurity_module.so ../libnginx-mod-security/debian/libnginx-mod-security/usr/lib/nginx/modules/


