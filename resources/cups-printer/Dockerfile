FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install CUPS and dependencies
RUN apt-get update && apt-get install -y \
    cups \
    cups-client \
    cups-bsd \
    cups-filters \
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    wget \
    libcups2 \
    libcupsimage2 \
    libglade2-0 \
    libxml2 \
    libjpeg8 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Canon UFR II driver
WORKDIR /tmp
RUN wget http://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz && \
    tar xzf linux-UFRIILT-drv-v500-uken-18.tar.gz && \
    cd linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian && \
    dpkg -i cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb || true && \
    apt-get update && apt-get install -f -y && \
    cd /tmp && rm -rf linux-UFRIILT-drv-v500-uken*

# Configure CUPS
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n  Allow all/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow all\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow all/' /etc/cups/cupsd.conf && \
    echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
    echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf

# Create cups user and set permissions
RUN useradd -r -G lpadmin -M cups && \
    echo "cups:cups" | chpasswd

# Expose CUPS port
EXPOSE 631

# Start CUPS
CMD ["/usr/sbin/cupsd", "-f"]
