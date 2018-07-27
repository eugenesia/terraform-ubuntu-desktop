#!/usr/bin/env bash
set -vx

export HOME=/root
export USER=root


#############################################
# Swap

# Add swap: https://help.ubuntu.com/community/SwapFaq
fallocate -l 2g /mnt/2GiB.swap
chmod 600 /mnt/2GiB.swap
mkswap /mnt/2GiB.swap
swapon /mnt/2GiB.swap

# Add the swap file details to /etc/fstab so it will be available at bootup:
echo '/mnt/2GiB.swap swap swap defaults 0 0' | sudo tee -a /etc/fstab

echo 'vm.swappiness=10' >> /etc/sysctl.conf

#############################################
# VNC

apt-get update
apt install -y xfce4 xfce4-goodies tightvncserver

echo '${vnc_password}' | vncpasswd -f > $HOME/.vnc/passwd

# Start vncserver
vncserver

vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak

cat > ~/.vnc/xstartup <<'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF

chmod +x ~/.vnc/xstartup

# Start server
vncserver

#################
# Android

cd $HOME
wget https://dl.google.com/dl/android/studio/ide-zips/3.1.3.0/android-studio-ide-173.4819257-linux.zip
unzip android-studio-ide-1.73.4819257


set +vx
