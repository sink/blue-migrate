# BlueMigrate

BlueMigrate is a cross-platform tool designed to facilitate the migration of Bluetooth pairing information from Windows to Linux systems.

## Usage Instructions

### Step 1: Pair Bluetooth Devices in Linux

### Step 2: Pair Bluetooth Devices in Windows
   Open Windows Command Prompt as Administrator and run the following command:
   ```sh
   export_windows_bluetooth.bat
   ```
   A bluetooth.info file will be generated in the same directory.

### Step 3: Import Bluetooth Information to Linux
Transfer the bluetooth.info file to your Linux system.
Open a terminal.
Navigate to the directory containing import_windows_bluetooth.sh and bluetooth.info.
Make the script executable if it isn't already:
```sh
chmod +x import_windows_bluetooth.sh
```
Execute the script with superuser privileges:
```sh
sudo ./import_windows_bluetooth.sh
```

### Step 4: Restart Bluetooth Service
After running the import script, restart the Bluetooth service to apply the changes:
```sh
sudo systemctl restart bluetooth
```
Verification
Verify that the Bluetooth devices are now paired in your Linux system.
You can use the bluetoothctl command to check the paired devices:
```sh
bluetoothctl devices
```