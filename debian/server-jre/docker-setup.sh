#!/bin/bash
set -Eeuo pipefail

cat << EOF > /etc/timezone
Asia/Shanghai
EOF

(rm -f /etc/localtime; cd /etc && ln -s /usr/share/zoneinfo/Asia/Shanghai localtime)

cat << EOF > /etc/default/locale
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
EOF

cat << EOF >> /etc/profile.d/locale.sh
#!/bin/bash
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
EOF
chmod +X /etc/profile.d/locale.sh

cat << EOF >  /etc/apt/apt.conf.d/80setting
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

cat << EOF > /etc/apt/sources.list
deb http://mirrors.163.com/debian/ stretch main contrib non-free
deb http://mirrors.163.com/debian/ stretch-updates main contrib non-free
deb http://mirrors.163.com/debian/ stretch-proposed-updates main contrib non-free
deb http://mirrors.163.com/debian/ stretch-backports main contrib non-free

#deb http://security.debian.org/debian-security/ stretch/updates main contrib non-free
deb http://security-cdn.debian.org/debian-security/ stretch/updates main contrib non-free
EOF

apt-get update && apt-get dist-upgrade -y
apt-get install -y locales

locale-gen en_US.UTF-8
localedef -c -i en_US -f UTF-8 en_US.UTF-8
localedef --list-archive

cat << EOF >> /root/.bashrc
export JAVA_HOME=/opt/jdk-8
export PATH=/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-8/bin:/opt/jdk-8/jre/bin
EOF

cd /opt && ln -s server-jre-8u192 jdk-8
rm -f /opt/docker-setup.sh
