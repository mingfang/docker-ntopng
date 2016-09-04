FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    TERM=xterm
RUN locale-gen en_US en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc
RUN apt-get update

# Runit
RUN apt-get install -y --no-install-recommends runit
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

# Utilities
RUN apt-get install -y --no-install-recommends vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc iproute

RUN wget http://apt-stable.ntop.org/14.04/all/apt-ntop-stable.deb && \
    dpkg -i apt-ntop-stable.deb && \
    rm apt-ntop-stable.deb
RUN apt-get update && \
    apt-get install -y pfring nprobe ntopng ntopng-data n2disk nbox

#Redis
RUN wget -O - http://download.redis.io/releases/redis-3.0.7.tar.gz | tar zx && \
    cd redis-* && \
    make -j4 && \
    make install && \
    cp redis.conf /etc/redis.conf && \
    rm -rf /redis-*

# Add runit services
COPY sv /etc/service 
ARG BUILD_INFO
LABEL BUILD_INFO=$BUILD_INFO

