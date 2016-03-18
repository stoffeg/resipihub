FROM resin/rpi-raspbian:jessie

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
    mosquitto \
#    raspberrypi-ui-mods \
#    raspberrypi-net-mods \
  && rm -rf /var/lib/apt/lists/*

#RUN pip install RPi.GPIO

RUN echo -e 127.0.0.1 \\t $HOSTNAME.localdomain \\t $HOSTNAME > /etc/hosts

WORKDIR /opt/dev

COPY . /opt/dev/

#CMD python ./bin/gpio_test.py > /dev/console

WORKDIR /opt/dev/bin
RUN unzip pilexa-1.0-SNAPSHOT.zip
RUN unzip STBWemoServer-1.0.2.zip

#COPY tty-input.conf /etc/systemd/system/launch.service.d/tty-input.conf

ENV INITSYSTEM on

RUN mkdir /var/run/sshd
RUN echo 'root:resin' | chpasswd
#ENTRYPOINT /usr/sbin/sshd

CMD ./pilexa-1.0-SNAPSHOT/bin/pilexa > /dev/console
#CMD ./bin/STBWemoServer
#CMD tail -f /dev/null
