#!/bin/bash

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

mv /opt/nginx-signing-key.gpg /etc/apt/trusted.gpg.d/

# apt-get install -y apt-transport-https ca-certificates

cat << EOF > /etc/apt/sources.list
deb http://mirrors.163.com/debian/ stretch main contrib non-free
deb http://mirrors.163.com/debian/ stretch-updates main contrib non-free
deb http://mirrors.163.com/debian/ stretch-proposed-updates main contrib non-free
deb http://mirrors.163.com/debian/ stretch-backports main contrib non-free

#deb http://security.debian.org/debian-security/ stretch/updates main contrib non-free
deb http://security-cdn.debian.org/debian-security/ stretch/updates main contrib non-free

deb http://nginx.org/packages/debian/ stretch nginx
EOF

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
cat << EOF > /etc/timezone
Asia/Shanghai
EOF

apt-get update && apt-get dist-upgrade -y
apt-get install --reinstall -y locales tzdata nginx netcat-openbsd

mv /opt/nginx.conf /etc/nginx/
mkdir -p /var/www && chown nginx:nginx /var/www

locale-gen en_US.UTF-8
localedef -c -i en_US -f UTF-8 en_US.UTF-8
localedef --list-archive

cat << EOF >> /root/.bashrc
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
EOF

cd /usr/lib/x86_64-linux-gnu/gconv && ls | grep -vE "UTF|GB18030|GBK" | xargs rm -f GBGBK.so

cp /usr/share/zoneinfo/Asia/Shanghai /tmp
rm -fr \
    /usr/share/i18n \
    /usr/share/zoneinfo \
    /usr/share/doc \
    /var/cache/debconf/*

mkdir -p /usr/share/zoneinfo/Asia
mv /tmp/Shanghai /usr/share/zoneinfo/Asia
cd /usr/share/zoneinfo/Asia && cp Shanghai ../PRC

apt-get --purge autoremove -y
rm -fr /opt/docker-setup.sh /var/lib/apt/lists/*
