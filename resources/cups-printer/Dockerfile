# Dockerfile
# Save this as: ~/lunix/resources/cups-printer/Dockerfile
FROM archlinux:latest

# Install base packages
RUN pacman -Sy --noconfirm cups base-devel git sudo

# Create build user for AUR
RUN useradd -m -G wheel builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Build and install cndrvcups-lt from AUR
USER builder
WORKDIR /home/builder
RUN git clone https://aur.archlinux.org/cndrvcups-lt.git && \
    cd cndrvcups-lt && \
    makepkg -si --noconfirm

# Switch back to root
USER root

# Configure CUPS to listen on all interfaces
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n  Allow all/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow all/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow all/' /etc/cups/cupsd.conf

# Expose CUPS port
EXPOSE 631

# Start CUPS in foreground
CMD ["cupsd", "-f"]
