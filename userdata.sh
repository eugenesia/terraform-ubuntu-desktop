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

mkdir $HOME/.vnc

passwdFile=$HOME/.vnc/passwd
echo '${vnc_password}' | vncpasswd -f > $passwdFile
chmod 600 $passwdFile

# Start vncserver
vncserver

vncserver -kill :1
xstartupFile=$HOME/.vnc/xstartup
mv $xstartupFile $xstartupFile.bak

cat > $xstartupFile <<'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF

chmod +x $xstartupFile

# Start server
vncserver

#################
# Android

cd $HOME
wget https://dl.google.com/dl/android/studio/ide-zips/3.1.3.0/android-studio-ide-173.4819257-linux.zip -O android-studio.zip
unzip android-studio.zip


set +vx
