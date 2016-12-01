# rancid-git docker container #

## Build ##

```
docker build -t biwhite/rancid-git .
```

## RUN ##

```
mkdir -p /path/rancid/{etc,home}
docker run -d --name rancid-git -v /path/rancid/etc:/etc/rancid \n
  -v /path/rancid/home:/home/rancid biwhite/rancid-git
```

## SETUP ##

```
docker exec -it rancid-git bash
cp /etc/rancid/rancid-git/etc/rancid.conf.sample /etc/rancid/rancid.conf
echo 'LIST_OF_GROUPS="devices"; export LIST_OF_GROUPS' >> /etc/rancid/rancid.conf
su - rancid
git config --global user.email "me@here"
git config --global user.name "My Name Here"
echo -e 'add user * USERNAME\nadd password * PASSWORD ENABLEPASS\nadd method * ssh telnet\nadd cyphertype * {aes256-cbc}\n' >> /home/rancid/.cloginrc
chmod 600 .cloginrc 
rancid-run
```

Logs for any errors in /home/rancid/var/logs/devices._yyyymmdd.hhmmss_

Check config grabs have appeared into /home/rancid/var/devices/configs/_hostname_

Check cron is running per 5 minutes/updating logs

## VOLUMES ##
  * /home/rancid - rancid working directory, logs and device configurations go here
  * /etc/rancid - rancid main configuration and cron file

## ISSUES ##

  * Email output of logs fails, need to build connection to an SMTP server into docker
