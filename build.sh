#!/bin/bash

mkdir /build/
cd /build/

pacman -Syy
pacman -S make gcc tar grep gawk wget --noconfirm
pacman -S libmcrypt libxml2 libjpeg libpng freetype2 --noconfirm

wget "http://cn2.php.net/distributions/php-7.1.10.tar.gz" -O php-7.1.10.tar.gz
tar -zxvf php-7.1.10.tar.gz
cd php-7.1.10/

./configure \
    --prefix=/usr/local \
    --disable-debug \
    --disable-rpath \
    --enable-fpm \
    --with-fpm-user=root \
    --with-fpm-group=root \
    --enable-mbstring \
    --enable-pdo \
    --enable-inline-optimization \
    --enable-sockets \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-pcntl \
    --enable-mbregex \
    --enable-zip \
    --with-config-file-path=/docker/config/php/etc \
    --with-config-file-scan-dir=/docker/config/php/etc/php.d \
    --with-mcrypt \
    --with-curl \
    --with-zlib \
    --with-mhash \
    --with-pcre-regex \
    --with-mysqli \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir

make
make install \
&& { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
&& make clean

echo '#!/bin/bash
php-fpm --fpm-config /docker/config/php/php-fpm.conf
' > /usr/bin/php-entrypoint
chmod +x /usr/bin/php-entrypoint

pacman -Rs make gcc tar grep gawk wget --noconfirm

# PHP 运行依赖 libltdl, 在清除 build 工具后安装
pacman -S libtool --noconfirm

rm -rf /var/cache/pacman/pkg
rm -rf /var/lib/pacman/sync
rm -rf /usr/share/man
rm -rf /usr/share/gtk-doc
rm -rf /usr/share/doc
rm /etc/ld.so.cache
rm -rf /tmp/*

rm -rf /build/
rm -rf /build.sh
