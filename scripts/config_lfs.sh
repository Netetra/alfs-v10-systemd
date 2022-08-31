#!/bin/bash

# 9.2.1.1. Network Device Naming
ln -s /dev/null /etc/systemd/network/99-default.link

cat > /etc/systemd/network/10-ether0.link << "EOF"
[Match]
# Change the MAC address as appropriate for your network device
MACAddress=12:34:45:78:90:AB

[Link]
Name=ether0
EOF

# 9.2.1.2. Static IP Configuration
cat > /etc/systemd/network/10-eth-static.network << "EOF"
[Match]
Name=ether0

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
Domains=
EOF

# 9.2.1.3. DHCP Configuration
cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=ether0

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF

# 9.2.2 Creating the /etc/resolv.conf File

ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver 8.8.8.8
nameserver 8.8.4.4

# End /etc/resolv.conf
EOF

# 9.2.3. Configuring the system hostname
echo "Raccoon" > /etc/hostname

# 9.2.4. Customizing the /etc/hosts File
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
127.0.1.1 LFS
192.168.86.28 LFS
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

# 9.8. Creating the /etc/inputrc File
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

# 9.9. Creating the /etc/shells File
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

# 9.10.2. Disabling Screen Clearing at Boot Time
mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
EOF

# 9.10.3. Disabling tmpfs for /tmp
ln -sfv /dev/null /etc/systemd/system/tmp.mount

# 9.10.8. Working with Core Dumps
mkdir -pv /etc/systemd/coredump.conf.d

cat > /etc/systemd/coredump.conf.d/maxuse.conf << EOF
[Coredump]
MaxUse=5G
EOF

# 10.2. Creating the /etc/fstab File
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/<xxx>     /            <fff>    defaults            1     1
/dev/<yyy>     swap         swap     pri=1               0     0

# End /etc/fstab
EOF

# Copy bashrc to root
cp /alfs/defaults/bashrc /root/.bashrc

# 10.3. Linux-5.8.3
/alfs/packages/linux.sh

# 10.4. Using GRUB to Set Up the Boot Process

# 11.1 The End

echo 10.0 > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Raccoon"
DISTRIB_RELEASE="10.0"
DISTRIB_CODENAME="White"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

cat > /etc/os-release << "EOF"
NAME="Raccoon"
VERSION="10.0"
ID=lfs
PRETTY_NAME="Raccoon 10.0"
VERSION_CODENAME="White"
EOF

echo
echo "Review section.."
echo "10.4. Using GRUB to Set Up the Boot Process"
echo "Not installing grub by default"
echo

exit
