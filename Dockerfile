FROM resin/rpi-raspbian:wheezy-20160106

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
    openjdk-7-jdk \
    lxde \
    lightdm \
    xinit \
#    raspberrypi-ui-mods \
#    raspberrypi-net-mods \
  && rm -rf /var/lib/apt/lists/*

#RUN pip install RPi.GPIO

WORKDIR /opt/dev

COPY . /opt/dev/

#CMD python ./bin/gpio_test.py > /dev/console

RUN git clone https://github.com/stoffeg/STBWemoServer.git
RUN cd STBWemoServer
RUN ./gradlew build
RUN cd ./build/distributions/
RUN cp STBWemoServer*.tar /opt/dev/
RUN cd /opt/dev
RUN tar xvf STBWemoServer*.tar

CMD ./bin/STBWemoServer

#RUN startx

#RUN mkdir /var/run/sshd \
#    && echo 'root:resin' | chpasswd \
#    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
#    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
