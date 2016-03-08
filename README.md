# docker-opensmtpd

Small container solution to run your own email server with your own domain.
Work in progress

OpenSMTPD container size : 51.2 MB based on alpine:3.3


## requirement

  * docker 1.10
  * docker-compose 1.6

## install

to start an opensmtpd server, listening on port 587 and 25

    git clone git@github.com:guillaumevincent/docker-opensmtpd.git
    cd docker-opensmtpd
    
edit env variables in `docker-compose.yml` file

    user=guillaume
    aliases=guillaume.vincent;gv;gvt;vincent;gvincent # optional
    password=password123!
    domain=oslab.fr
    ssl_country_name=FR
    ssl_state=Gironde
    ssl_city=Bordeaux
    ssl_company=Oslab
    ssl_department=IT Department

run

    docker-compose build && docker-compose up -d


## TODO

  * container with spamassassin + amavis for anti spam
  * container with dovecot for IMAP
  * container with roundcube for webmail

