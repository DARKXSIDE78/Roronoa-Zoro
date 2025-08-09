FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=8080 \
    VNC_PASSWORD=1234

# Install basic tools and Chrome dependencies
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    novnc websockify \
    x11vnc xvfb \
    wget unzip curl \
    gnupg ca-certificates \
    supervisor \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Set up noVNC
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd $VNC_PASSWORD /root/.vnc/passwd && \
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
