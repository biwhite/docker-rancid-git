FROM alpine:latest
RUN apk update
RUN apk add bash expect git openssh-client
RUN adduser -D -s /bin/sh rancid
RUN apk add --no-cache --virtual .builddeps build-base alpine-sdk autoconf automake gcc make
RUN  cd /usr/bin && ln -s aclocal aclocal-1.14 && ln -s automake automake-1.14 && \
     cd /root && \
     git clone https://github.com/dotwaffle/rancid-git.git && \
     cd rancid-git/ && \
     chown -R rancid /home/rancid && \
     ./configure --prefix=/home/rancid --mandir=/usr/share/man --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc/rancid --with-git --datarootdir=/usr/share && \
     make install 
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
# setup sample config, default cron, 20 minute polling
RUN cp /usr/share/rancid/rancid.conf.sample /etc/rancid && \
    echo '*/20 * * * * /usr/bin/rancid-run >/home/rancid/var/logs/cron.log 2>/home/rancid/var/logs/cron.err' > /etc/rancid/rancid.cron
RUN touch /home/rancid/.cloginrc
ADD root /
# copy in sample files
#
VOLUME /home/rancid
VOLUME /etc/rancid
# write README file
# advise on git config/read from ENV and adjust accordingly
# advise to add entry to GROUPS list in rancid.conf, run rancid-cvs as 'rancid' user to pre-create folders
ENTRYPOINT ["/init"]
