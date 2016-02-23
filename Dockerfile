FROM resin/rpi-raspbian:wheezy-20160106

RUN apt-get update \
  && apt-get install -yq \
    usbmount \
    openssh-server \
    python3-dev \
    python3-rpi.gpio \
    python3-picamera \
    curl \
    strace \
    tcpdump \
    oracle-java8-jdk \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
    && echo 'root:resin' | chpasswd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
