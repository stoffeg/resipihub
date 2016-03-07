FROM resin/rpi-raspbian:wheezy

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
    unzip \
#    raspberrypi-ui-mods \
#    raspberrypi-net-mods \
  && rm -rf /var/lib/apt/lists/*

#RUN pip install RPi.GPIO

WORKDIR /opt/dev

COPY . /opt/dev/

#CMD python ./bin/gpio_test.py > /dev/console

RUN git clone git://github.com/stoffeg/STBWemoServer.git
RUN cd STBWemoServer
#RUN ./gradlew build
#RUN cd ./build/distributions/
#RUN cp STBWemoServer-*.tar /opt/dev/
#RUN cd /opt/dev
#RUN tar xvf STBWemoServer-*.tar

COPY tty-input.conf /etc/systemd/system/launch.service.d/tty-input.conf

ENV INITSYSTEM on

#CMD ./bin/STBWemoServer

RUN mkdir /var/run/sshd \
    && echo 'root:resin' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
CMD tail -f /dev/null
