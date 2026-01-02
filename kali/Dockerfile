# Kali Linux Attack Box with Web Terminal
# Includes: Metasploit, Nmap, Hydra, John, SQLMap, and ttyd for browser access

FROM kalilinux/kali-rolling

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install pentesting tools + ttyd
RUN apt-get update && apt-get install -y \
    # Core pentesting tools
    metasploit-framework \
    nmap \
    hydra \
    john \
    sqlmap \
    nikto \
    dirb \
    gobuster \
    netcat-openbsd \
    curl \
    wget \
    vim \
    git \
    # Web terminal
    ttyd \
    # Utilities
    iputils-ping \
    net-tools \
    dnsutils \
    tmux \
    zsh \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create persistent directories
RUN mkdir -p /root/.msf4 /root/loot /root/wordlists

# Set up a nice prompt
RUN echo 'PS1="\[\033[1;31m\]kali\[\033[0m\]@\[\033[1;34m\]attackbox\[\033[0m\]:\[\033[1;32m\]\w\[\033[0m\]# "' >> /root/.bashrc

# Add useful aliases
RUN echo 'alias ll="ls -la"' >> /root/.bashrc && \
    echo 'alias ms="msfconsole"' >> /root/.bashrc && \
    echo 'alias scan="nmap -sV"' >> /root/.bashrc

# Initialize Metasploit database on first run
RUN echo '#!/bin/bash\nif [ ! -f /root/.msf4/.db_initialized ]; then\n  msfdb init\n  touch /root/.msf4/.db_initialized\nfi\nexec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

# Expose ttyd port
EXPOSE 7681

WORKDIR /root

# Start ttyd with bash
# -W: Writable (allow input)
# -t: Terminal options
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ttyd", "-W", "-t", "fontSize=14", "-t", "theme={'background':'#1a1a2e','foreground':'#eee'}", "bash"]
