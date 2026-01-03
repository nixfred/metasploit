# Vulnerable SSH Server for Brute Force Practice
# Password: password123 (intentionally weak for learning)

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    # Set root password to 'password123' (common weak password)
    echo 'root:password123' | chpasswd && \
    # Allow root login via SSH
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
