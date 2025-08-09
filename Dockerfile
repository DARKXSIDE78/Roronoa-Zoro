FROM dorowu/ubuntu-desktop-lxde-vnc

# Install Chrome & dependencies
RUN apt-get update && \
    apt-get install -y wget ffmpeg python3 python3-pip git && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb && \
    apt-get clean

# Copy bot script into container
WORKDIR /root
COPY runbot.sh /root/runbot.sh
RUN chmod +x /root/runbot.sh

# Expose VNC & noVNC ports
EXPOSE 80
EXPOSE 5900

# Start GUI and bot
CMD /root/runbot.sh &
