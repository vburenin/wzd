FROM debian:buster

LABEL maintainer="Andrey Kuvshinov"

ENV bindaddr "127.0.0.1:9699"
ENV readtimeout 60
ENV readheadertimeout 5
ENV writetimeout 60
ENV idletimeout 60
ENV realheader "X-Real-IP"
ENV charset "UTF-8"
ENV debugmode false
ENV pidfile "/run/wzd/wzd.pid"
ENV logdir "/var/log/wzd"
ENV logmode 0640
ENV defsleep 1
ENV cmpsched true
ENV cmpdir "/var/lib/wzd"
ENV cmptime 30
ENV cmpcount 100
ENV cmpcheck 5

ENV host "localhost"
ENV root "/var/storage"
ENV upload true
ENV delete true
ENV compaction true
ENV writeintegrity true
ENV readintegrity true
ENV trytimes 5
ENV opentries 5
ENV locktimeout 5
ENV fmaxsize 1048576
ENV args false
ENV getbolt false
ENV getcount true
ENV getkeys true
ENV nonunique false
ENV cctrl 0
ENV minbuffer 262144
ENV lowbuffer 1048576
ENV medbuffer 67108864
ENV bigbuffer 536870912
ENV filemode 0640
ENV dirmode 0750
ENV delbolt false
ENV deldir false

RUN groupadd wzd
RUN useradd wzd -g wzd

RUN mkdir -p /etc/wzd
RUN mkdir -p ${logdir}
RUN mkdir -p ${cmpdir}
RUN mkdir -p ${root}
RUN mkdir -p `dirname ${pidfile}`

RUN chown wzd.wzd ${logdir}
RUN chown wzd.wzd ${cmpdir}
RUN chown wzd.wzd `dirname ${pidfile}`

RUN apt-get update
RUN apt-get -y install nginx sed util-linux

RUN rm -f /etc/nginx/sites-available/*
RUN rm -f /etc/nginx/sites-enabled/*

COPY wzd /usr/bin/
COPY conf/wzd/wzd-docker.conf /etc/wzd/wzd.conf
COPY conf/nginx/localhost-docker.conf /etc/nginx/sites-available/localhost.conf
COPY scripts/docker/start.sh /
COPY LICENSE /

RUN test -L /etc/nginx/sites-enabled/localhost.conf || ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/localhost.conf

EXPOSE 80/tcp

ENTRYPOINT ["/start.sh"]
