FROM ubuntu:14.04
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV CONTAINER 1

#RUN echo "deb http://ppa.launchpad.net/semiosis/ubuntu-glusterfs-3.4/ubuntu trusty main \n\
#">> /etc/apt/sources.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12

RUN apt-get update \
    && apt-get install -y --no-install-recommends glusterfs-server glusterfs-client keepalived supervisor attr \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD startup.sh /app/
ADD conf/supervisord.conf /etc/supervisor/conf.d/
ADD conf/glusterd.vol /etc/glusterfs/
ADD conf/keepalived.conf /etc/keepalived/
ADD bin/glusterfs-keepalived /usr/local/bin/
WORKDIR /app
ENTRYPOINT ["/app/startup.sh"]
