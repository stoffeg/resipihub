FROM resin/raspberrypi-systemd:jessie

COPY raspberrypi.gpg.key /key/
RUN echo 'deb http://archive.raspberrypi.org/debian/ wheezy main' >> /etc/apt/sources.list.d/raspi.list && \
    echo oracle-java8-jdk shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-key add /key/raspberrypi.gpg.key

RUN apt-get update \
#  && upgrade \
#  && dist-upgrade \
  && apt-get install -yq \
    usbmount \
    openssh-server \
    git-core \
    python-dev \
    python-pip \
    build-essential \
    curl \
    strace \
    tcpdump \
    oracle-java8-jdk \
    lxde \
    lightdm \
    xinit \
    xserver-xorg \
    vim \
    unzip \
    bluez \
    libjson-glib-1.0-0 \
    libsoup2.4-1 \
    libev4 \
    libc-ares2 \
#  && rm -rf /var/lib/apt/lists/*

#RUN echo -e 127.0.0.1 \\t $HOSTNAME.localdomain \\t $HOSTNAME > /etc/hosts

WORKDIR /opt/dev

COPY . /opt/dev/

#CMD python ./bin/gpio_test.py > /dev/console

WORKDIR /opt/dev/bin
RUN unzip pilexa-1.0-SNAPSHOT.zip
RUN unzip STBWemoServer-1.0.3.zip

#Flic
#//80:E4:DA:70:A2:99
#//80:E4:DA:71:21:30

#Mosquitto
RUN dpkg -i libuv1_1.8.0-1_armhf.deb
RUN dpkg -i libwebsockets7_1.7.3-1_armhf.deb
RUN dpkg -i libmosquitto1_1.4.8-1_armhf.deb
RUN dpkg -i mosquitto_1.4.8-1_armhf.deb

#COPY tty-input.conf /etc/systemd/system/launch.service.d/tty-input.conf

ENV INITSYSTEM on

#RUN mkdir /var/run/sshd
#RUN echo 'root:resin' | chpasswd

RUN mkdir /var/run/sshd \
    && echo 'root:resin' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

CMD ./pilexa-1.0-SNAPSHOT/util/start.sh
#CMD ./pilexa-1.0-SNAPSHOT/bin/pilexa > /dev/console
#CMD ./bin/STBWemoServer
#CMD tail -f /dev/null
