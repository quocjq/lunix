# Dockerfile (with paru)
FROM archlinux:latest

# Configure pacman for better performance
RUN sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf && \
    sed -i 's/#Color/Color/' /etc/pacman.conf

# Initialize pacman keyring and update mirrorlist with reflector
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --noconfirm archlinux-keyring reflector && \
    reflector --country Vietnam,Singapore,Japan,Taiwan,China --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm

# Install dependencies (paru needs rust)
RUN pacman -S --noconfirm --needed cups base-devel git sudo rust

# Create build user for AUR
RUN useradd -m -G wheel builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install paru as AUR helper
USER builder
WORKDIR /home/builder
RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf paru-bin

# Install cndrvcups-lt from AUR using paru
RUN paru -S --noconfirm cndrvcups-lt

# Switch back to root and clean up
USER root
RUN pacman -Rns --noconfirm base-devel git rust && \
    pacman -Scc --noconfirm && \
    rm -rf /home/builder/.cache

# Configure CUPS to listen on all interfaces
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/>/<Location \/>\n  Allow all/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow all/' /etc/cups/cupsd.conf && \
    sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow all/' /etc/cups/cupsd.conf

# Expose CUPS port
EXPOSE 631

# Start CUPS in foreground
CMD ["cupsd", "-f"]
