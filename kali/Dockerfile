# Kali Linux Attack Box with Web Terminal
# Your permanent pentesting companion - always running, always ready
#
# Tools: Metasploit, SET, Nmap, Hydra, John, SQLMap, Nikto, Gobuster
# Access: http://localhost:7681 (web terminal) or docker exec -it kali bash

FROM kalilinux/kali-rolling

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Use a reliable Kali mirror (cloudflare)
RUN echo "deb http://kali.download/kali kali-rolling main contrib non-free non-free-firmware" > /etc/apt/sources.list

# Update and install pentesting tools (with retry logic for flaky mirrors)
RUN apt-get update && apt-get install -y --fix-missing \
    # Core pentesting tools
    metasploit-framework \
    set \
    nmap \
    hydra \
    john \
    sqlmap \
    nikto \
    dirb \
    gobuster \
    wfuzz \
    netcat-openbsd \
    # Network tools
    curl \
    wget \
    whois \
    dnsutils \
    iputils-ping \
    net-tools \
    tcpdump \
    sshpass \
    smbclient \
    # Editors and utils
    vim \
    nano \
    git \
    tmux \
    zsh \
    jq \
    tree \
    lsof \
    # Python for scripts
    python3 \
    python3-pip \
    # Dependencies for ttyd
    cmake \
    g++ \
    pkg-config \
    libwebsockets-dev \
    libjson-c-dev \
    libssl-dev \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ttyd (web terminal) from source - not available in Kali repos
RUN git clone https://github.com/tsl0922/ttyd.git /tmp/ttyd && \
    cd /tmp/ttyd && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install && \
    rm -rf /tmp/ttyd

# Create persistent directories (will be overlaid by volume mounts)
RUN mkdir -p /root/.msf4 /root/loot /root/wordlists /root/scripts

# Copy custom ttyd index.html (disables leave warning)
COPY index.html /usr/share/ttyd/index.html

# Set up a nice prompt
RUN echo 'PS1="\[\033[1;31m\]kali\[\033[0m\]@\[\033[1;34m\]attackbox\[\033[0m\]:\[\033[1;32m\]\w\[\033[0m\]# "' >> /root/.bashrc

# Add useful aliases
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias ms="msfconsole"' >> /root/.bashrc && \
    echo 'alias settool="setoolkit"' >> /root/.bashrc && \
    echo 'alias scan="nmap -sV"' >> /root/.bashrc && \
    echo 'alias serve="python3 -m http.server 8888"' >> /root/.bashrc && \
    echo 'export PATH="$PATH:/root/.msf4/scripts"' >> /root/.bashrc

# Initialize Metasploit database on first run
# Must start PostgreSQL manually (no systemd in container)
RUN echo '#!/bin/bash\n\
# Start PostgreSQL\n\
service postgresql start\n\
sleep 2\n\
\n\
# Initialize msfdb if not done\n\
if [ ! -f /root/.msf4/.db_initialized ]; then\n\
  msfdb init\n\
  touch /root/.msf4/.db_initialized\n\
fi\n\
\n\
exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

# Expose ttyd port
EXPOSE 7681

WORKDIR /root

# Start ttyd with bash
# -W: Writable (allow input)
# -I: Custom index.html (disables leave warning)
# -t: Terminal options for theming
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ttyd", "-W", "-I", "/usr/share/ttyd/index.html", "-t", "fontSize=14", "-t", "theme={'background':'#1a1a2e','foreground':'#eee'}", "bash"]
