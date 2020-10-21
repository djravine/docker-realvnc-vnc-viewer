FROM ubuntu:20.04

LABEL maintainer="Adan Rehtla <adan.rehtla@intellipharm.com.au>"

ARG REALVNC_DEB="VNC-Viewer-6.20.529-Linux-x64.deb"
ARG USER=vnc
ARG HOME=/home/$USER

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        x11-apps \
    && wget --no-check-certificate -nv "https://www.realvnc.com/download/file/viewer.files/$REALVNC_DEB" -O /tmp/realvnc.deb \
    && apt-get install -y /tmp/realvnc.deb \
    && rm -f /tmp/realvnc.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 $USER
RUN useradd -d $HOME -s /bin/bash -m $USER -u 1000 -g 1000 \
    && echo $USER:ubuntu | chpasswd \
    && adduser $USER sudo

USER $USER
ENV HOME $HOME
WORKDIR $HOME

ENTRYPOINT ["/usr/bin/vncviewer"]