FROM resin/rpi-raspbian:wheezy-20160106

RUN apt-get update \
  && apt-get install -yq \
    usbmount \
    openssh-server \
    python-dev \
    python-pip \
    build-essential \
    curl \
    strace \
    tcpdump \
    openjdk-7-jdk \
  && rm -rf /var/lib/apt/lists/*

RUN pip install RPi.GPIO

WORKDIR /opt/dev

COPY . /opt/dev/

CMD python ./bin/gpio_test.py > /dev/console

RUN mkdir /var/run/sshd \
    && echo 'root:resin' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
