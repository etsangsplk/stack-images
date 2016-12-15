#!/bin/bash

exec 2>&1
set -e
set -x

apt-get update
apt-get install -y --force-yes \
    autoconf \
    bison \
    build-essential \
    libacl1-dev \
    libapparmor-dev \
    libapt-pkg-dev \
    libattr1-dev \
    libaudit-dev \
    libbsd-dev \
    libbz2-dev \
    libcairo2-dev \
    libcap-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libev-dev \
    libevent-dev \
    libexif-dev \
    libffi-dev \
    libgcrypt20-dev \
    libgd-dev \
    libgdbm-dev \
    libgeoip-dev \
    libglib2.0-dev \
    libgnutls-dev \
    libgs-dev \
    libicu-dev \
    libidn11-dev \
    libjpeg-dev \
    libkeyutils-dev \
    libkmod-dev \
    libkrb5-dev \
    libldap2-dev \
    liblz4-dev \
    libmagic-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libmysqlclient-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnetpbm10-dev \
    libpam0g-dev \
    libpopt-dev \
    libpq-dev \
    librabbitmq-dev \
    libreadline-dev \
    librtmp-dev \
    libselinux1-dev \
    libsemanage1-dev \
    libssl-dev \
    libsystemd-dev \
    libudev-dev \
    libuv1-dev \
    libwrap0-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    postgresql-server-dev-9.5 \
    python-dev \
    ruby-dev \
    zlib1g-dev \

cd /
rm -rf /var/cache/apt/archives/*.deb
rm -rf /root/*
rm -rf /tmp/*

# remove SUID and SGID flags from all binaries
function pruned_find() {
  find / -type d \( -name dev -o -name proc \) -prune -o $@ -print
}

pruned_find -perm /u+s | xargs -r chmod u-s
pruned_find -perm /g+s | xargs -r chmod g-s

# remove non-root ownership of files
#chown root:root /var/lib/libuuid; true

# display build summary
set +x
echo -e "\nRemaining suspicious security bits:"
(
  pruned_find ! -user root
  pruned_find -perm /u+s
  pruned_find -perm /g+s
  pruned_find -perm /+t
) | sed -u "s/^/  /"

echo -e "\nSuccess!"
exit 0
