# Dockerfile
# Save this as: ~/lunix/resources/cups-printer/Dockerfile
FROM debian:bookworm-slim

# Install CUPS and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cups \
    cups-client \
    cups-bsd \
    wget \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Canon LBP6230dn driver
RUN cd "http://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz/linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian" && \
    dpkg -i cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb

# Backup original cupsd.conf
RUN cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.bak

# Create necessary directories
RUN mkdir -p /var/run/cups /var/spool/cups /var/cache/cups

# Expose CUPS port
EXPOSE 631

# Start CUPS in foreground
CMD ["/usr/sbin/cupsd", "-f"]
