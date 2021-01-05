#!/usr/bin/make -f
export DH_VERBOSE=1

NGINX_VERSION := 1.14.2

export DEB_BUILD_MAINT_OPTIONS=hardening=+all
debian_cflags:=$(shell dpkg-buildflags --get CFLAGS) -fPIC $(shell dpkg-buildflags --get CPPFLAGS)
debian_ldflags:=$(shell dpkg-buildflags --get LDFLAGS) -fPIC

distclean:

build:
	cd .. && rm -rf nginx-* nginx_* && apt source nginx=$(NGINX_VERSION)
	cd nginx-$(NGINX_VERSION)
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
	    --add-dynamic-module=../libnginx-mod-security/
	make -j 8

install:
	cd ../nginx-$(NGINX_VERSION) && cp ./objs/ngx_http_modsecurity_module.so $(DESTDIR)/usr/lib/nginx/modules/


