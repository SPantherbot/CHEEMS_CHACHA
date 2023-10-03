# Use the latest Ubuntu base image
FROM ubuntu:latest

# Update and upgrade the system, install locales, and set the locale
RUN apt update -y > /dev/null 2>&1 \
    && apt upgrade -y > /dev/null 2>&1 \
    && apt install locales -y \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set the desired locale
ENV LANG en_US.utf8

# Set NGROK_TOKEN as an environment variable
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Install necessary packages
RUN apt install ssh wget unzip -y > /dev/null 2>&1

# Download and unzip ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1 \
    && unzip ngrok.zip

# Create a startup script named odiyaant.sh
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >> /odiyaant.sh \
    && echo "./ngrok tcp 22 &>/dev/null &" >> /odiyaant.sh \
    && echo 'mkdir -p /run/sshd' >> /odiyaant.sh \
    && echo '/usr/sbin/sshd -D' >> /odiyaant.sh

# Enable root login and password authentication
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Set the root password (replace 'your_password' with your desired password)
RUN echo root:iamgoodboy | chpasswd

# Start the SSH service and make the startup script executable
RUN service ssh start \
    && chmod +x /odiyaant.sh

# Expose the desired ports
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

# Start the startup script odiyaant.sh as the container's command
CMD /odiyaant.sh
