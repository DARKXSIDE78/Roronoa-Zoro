FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=8080 \
    VNC_PASSWORD=1234

# Install desktop, VNC, supervisor, git, wget
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    x11vnc xvfb \
    python3 python3-pip \
    git wget curl unzip \
    supervisor \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install noVNC manually
RUN mkdir -p /opt/novnc && \
    wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /opt/novnc/novnc.zip && \
    cd /opt/novnc && unzip novnc.zip && mv noVNC-master novnc && rm novnc.zip && \
    ln -s /opt/novnc/novnc/vnc_lite.html /opt/novnc/novnc/index.html

# Set VNC password
RUN mkdir -p /root/.vnc && x11vnc -storepasswd $VNC_PASSWORD /root/.vnc/passwd

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
