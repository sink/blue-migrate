# BlueMigrate

BlueMigrate is a cross-platform tool designed to facilitate the migration of Bluetooth pairing information from Windows to Linux systems.

## Usage Instructions

### Step 1: Pair Bluetooth Devices in Linux
1. Ensure your Bluetooth adapter is enabled in your Linux system.
2. Use your preferred method to pair the Bluetooth devices you want to migrate. You can use the `bluetoothctl` command-line tool or a graphical interface like the Settings app.

### Step 2: Pair Bluetooth Devices in Windows
1. Ensure your Bluetooth adapter is enabled in your Windows system.
2. Pair the same Bluetooth devices in Windows.
3. Open a Command Prompt or PowerShell window.
4. Navigate to the directory containing `export_windows_bluetooth.bat`.
5. Execute the batch file:
   ```sh
   export_windows_bluetooth.bat
   ```
6.  A bluetooth.info file will be generated in the same directory.

### Step 3: Import Bluetooth Information to Linux
Transfer the bluetooth.info file to your Linux system.
Open a terminal.
Navigate to the directory containing import_windows_bluetooth.sh.
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
bluetoothctl paired-devices
```

### Additional Notes
Ensure that both your Windows and Linux systems have the necessary permissions to access and modify Bluetooth settings.
If you encounter any issues, refer to the project's documentation or contact the support team for assistance.