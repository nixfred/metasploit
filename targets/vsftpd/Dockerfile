# vsftpd 2.3.4 with backdoor
# The famous smiley face backdoor - username containing :) opens shell on port 6200
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libcap-dev \
    libpam0g-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and compile vsftpd 2.3.4 (contains the backdoor)
WORKDIR /tmp
RUN wget https://github.com/nikdubois/vsftpd-2.3.4-infected/archive/refs/heads/vsftpd_original.tar.gz -O vsftpd.tar.gz \
    && tar xzf vsftpd.tar.gz \
    && cd vsftpd-2.3.4-infected-vsftpd_original \
    && sed -i 's/^LIBS\s*=.*/LIBS = -lcrypt -lcap -lpam/' Makefile \
    && make \
    && cp vsftpd /usr/local/sbin/ \
    && mkdir -p /var/ftp /var/run/vsftpd/empty /etc/vsftpd \
    && useradd -d /var/ftp ftp 2>/dev/null || true

# vsftpd config
RUN echo "listen=YES" > /etc/vsftpd.conf \
    && echo "anonymous_enable=YES" >> /etc/vsftpd.conf \
    && echo "local_enable=YES" >> /etc/vsftpd.conf \
    && echo "write_enable=YES" >> /etc/vsftpd.conf \
    && echo "anon_upload_enable=YES" >> /etc/vsftpd.conf \
    && echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd.conf \
    && echo "dirmessage_enable=YES" >> /etc/vsftpd.conf \
    && echo "xferlog_enable=YES" >> /etc/vsftpd.conf \
    && echo "connect_from_port_20=YES" >> /etc/vsftpd.conf \
    && echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf

EXPOSE 21 6200

CMD ["/usr/local/sbin/vsftpd", "/etc/vsftpd.conf"]
