#!/bin/bash

# 1. Create pool ZFS
zpool create -f mypool /dev/sdX   # Replace /dev/sdX with your disks (or another pool if available)

# 2. Create datasets for each user (PC1, PC2, PC3 et PC4)
zfs create mypool/PC1
zfs create mypool/PC2
zfs create mypool/PC3
zfs create mypool/SharedData

# 3. Set quotas for PC1, PC2 and PC3 (limit to 500GB)
zfs set quota=500G mypool/PC1
zfs set quota=500G mypool/PC2
zfs set quota=500G mypool/PC3

# 4. Create a TrueNAS user for each PC and define their permissions
# PC1: Read only
useradd -m pc1
chown -R pc1:pc1 /mnt/mypool/PC1
chmod -R 755 /mnt/mypool/PC1    # 755 provides read-only user access

# PC2: Read only
useradd -m pc2
chown -R pc2:pc2 /mnt/mypool/PC2
chmod -R 755 /mnt/mypool/PC2

# PC3: Read only
useradd -m pc3
chown -R pc3:pc3 /mnt/mypool/PC3
chmod -R 755 /mnt/mypool/PC3

# PC4: ead and modify data (Read/Write on SharedData)
useradd -m pc4
chown -R pc4:pc4 /mnt/mypool/SharedData
chmod -R 775 /mnt/mypool/SharedData  # 775 allows pc4 to read and modify

# 5. Configure SMB shares for each dataset
# Install Samba if necessary
apt-get install -y samba

# Configuring the smb.conf file for shares

cat <<EOT >> /etc/samba/smb.conf

# PC1 - Read-only access
[PC1]
    path = /mnt/mypool/PC1
    valid users = pc1
    read only = yes
    browseable = yes
    guest ok = no

# PC2 - Read-only access
[PC2]
    path = /mnt/mypool/PC2
    valid users = pc2
    read only = yes
    browseable = yes
    guest ok = no

# PC3 - Read-only access
[PC3]
    path = /mnt/mypool/PC3
    valid users = pc3
    read only = yes
    browseable = yes
    guest ok = no

# SharedData - Read/write access for PC4
[SharedData]
    path = /mnt/mypool/SharedData
    valid users = pc4
    read only = no
    write list = pc4
    browseable = yes
    guest ok = no

EOT

# Restart the Samba service to apply the changes
systemctl restart smbd
systemctl enable smbd

# Add Samba users for each PC
(echo "password1"; echo "password1") | smbpasswd -a pc1
(echo "password2"; echo "password2") | smbpasswd -a pc2
(echo "password3"; echo "password3") | smbpasswd -a pc3
(echo "adminpassword"; echo "adminpassword") | smbpasswd -a pc4

echo "Configuration successfully completed. The server is now accessible to all 4 computers."
