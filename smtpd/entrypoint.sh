#!/bin/sh

# supervisor
mkdir /etc/supervisor.d

cat > /etc/supervisor.d/opensmtpd.ini <<EOF
[program:opensmtpd]
command=/usr/sbin/smtpd -d
EOF

# TLS
openssl genrsa -out /etc/ssl/private/mail.$domain.key 4096
openssl req -new -x509 -key /etc/ssl/private/mail.$domain.key -out /etc/ssl/certs/mail.$domain.crt -days 730 -subj "/C=$ssl_country_name/ST=$ssl_state/L=$ssl_city/O=$ssl_company/OU=$ssl_department/CN=$domain"
chmod 600 /etc/ssl/private/mail.$domain.key
chmod 644 /etc/ssl/certs/mail.$domain.crt

# unix user 
adduser -D -H -g "" $user
echo "$user:$password" | chpasswd

# smtpd.conf
cat > /etc/smtpd/smtpd.conf <<EOF
# This is the smtpd server system-wide configuration file.
# See smtpd.conf(5) for more information.

pki mail.$domain key "/etc/ssl/private/mail.$domain.key"
pki mail.$domain certificate "/etc/ssl/certs/mail.$domain.crt"

# To accept external mail, replace with: listen on all
# listen on localhost
listen on eth0 port 25 hostname mail.$domain tls pki mail.$domain
listen on eth0 port 587 hostname mail.$domain tls-require pki mail.$domain auth mask-source

# If you edit the file, you have to run "smtpctl update table aliases"
table aliases file:/etc/smtpd/aliases

accept from any for domain "$domain" alias <aliases> deliver to maildir "/var/spool/mail/$user"

accept from local for any relay
EOF

# aliases
sed -i '/# root: /c\root: '"$user"'' /etc/smtpd/aliases

if [ -z "$aliases" ]; 
then 
    echo "aliases is unset"; 
else
    echo -e "\n" >> /etc/smtpd/aliases
    for alias in $(echo $aliases | tr ";" "\n")
    do
      echo add alias $alias
      echo "$alias: $user" >> /etc/smtpd/aliases
    done
fi

newaliases

# run supervisord
exec "$@"