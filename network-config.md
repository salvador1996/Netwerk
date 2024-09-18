# Network configuration on TrueNAS Scale

## Step 1: Access the network interface

1. Connect to the TrueNAS Scale interface via the server's IP address.
2. Go to **Network** in the control panel.

## Step 2: Configure a network interface

1. Click on the network interface you wish to configure (e.g. `aod2s0`).
2. Configure the static IP, subnet mask and gateway:
   - IP: `192.168.1.100`
   - Subnet mask: `255.255.255.0`.
   - Gateway: `192.168.1.1`.
3. Apply changes and check connectivity.
