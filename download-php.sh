#!/bin/bash

# PHP version can be passed as an argument for example ./download-php 7.1.0
PHP_VERSION="${1:-7.1.2}"
GPG_KEY_1="A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0"
GPG_KEY_2="528995BFEDFBA7191D46839EF9BA0ADA31CBD89E"
PHP_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror"
PHP_ASC_URL="https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror"
PHP_SHA256="d815a0c39fd57bab1434a77ff0610fb507c22f790c66cd6f26e27030c4b3e971"
PHP_MD5="d79afea1870277c86fac903566fb6c5d"

curl -o php.tar.xz -OL $PHP_URL
if [ -n "$PHP_SHA256" ]; then
    echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -
fi;
if [ -n "$PHP_MD5" ]; then
    echo "$PHP_MD5 *php.tar.xz" | md5sum -c -
fi;
if [ -n "$PHP_ASC_URL" ]; then
    curl -o php.tar.xz.asc -OL "$PHP_ASC_URL"
    export GNUPGHOME="$(mktemp -d)"
    for key in $GPG_KEY_1 $GPG_KEY_2; do
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $key
        gpg --fingerprint $key
    done;
    gpg --batch --verify php.tar.xz{.asc*,}
    rm -r "$GNUPGHOME"
fi;
tar -Jxf php.tar.xz
rm php.tar.xz php.tar.xz.asc
