# noVNC + TurboVNC + VirtualGL
# http://novnc.com
# https://turbovnc.org
# https://virtualgl.org

# docker build -t turbovnc .
# docker run --init --runtime=nvidia --name=turbovnc --rm -i -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -p 5901:5901 turbovnc
# docker exec -ti turbovnc vglrun glxspheres64

FROM nvidia/opengl:1.2-glvnd-runtime

ARG TURBOVNC_VERSION=2.2.6
ARG VIRTUALGL_VERSION=2.6.5
#ARG LIBJPEG_VERSION=1.5.2

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        libc6-dev \
        libglu1 \
        libglu1:i386 \
        libsm6 \
        libxv1 \
        libxv1:i386 \
        libxtst6 \
        libxtst6:i386\
        make \
        mesa-utils \
        python \
        python-numpy \
        x11-xkb-utils \
        xauth \
        xfonts-base \
        xkb-data && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O https://pilotfiber.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        #-O https://pilotfiber.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O https://pilotfiber.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O https://pilotfiber.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver \
    /opt/VirtualGL/bin/vglserver_config -config

ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

# RUN echo 'no-remote-connections\n\
# no-httpd\n\
# no-x11-tcp-connections\n\
# no-pam-sessions\n\
# permitted-security-types = otp\
# ' > /etc/turbovncserver-security.conf

EXPOSE 5901
ENV DISPLAY :1