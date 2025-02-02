#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SRC_FILE=systemd-246.tar.gz
SRC_FOLDER=systemd-246

cd /sources

tar xvf $SRC_FILE

cd $SRC_FOLDER

ln -sf /bin/true /usr/bin/xsltproc

tar -xf ../systemd-man-pages-246.tar.xz

sed '177,$ d' -i src/resolve/meson.build

sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in

mkdir -p build
cd       build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=true                    \
      -Ddocdir=/usr/share/doc/systemd-246 \
      ..

LANG=en_US.UTF-8 ninja
LANG=en_US.UTF-8 ninja install

rm -f /usr/bin/xsltproc

systemd-machine-id-setup

systemctl preset-all

systemctl disable systemd-time-wait-sync.service

rm -f /usr/lib/sysctl.d/50-pid-max.conf

cd /sources

rm -rf $SRC_FOLDER

echo Deleting $SRC_FOLDER
echo Done with $SRC_FILE