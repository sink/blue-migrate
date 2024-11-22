#!/bin/bash

# Check if the input file exists
input_file="bluetooth.info"
if [ ! -f "$input_file" ]; then
    echo "File $input_file does not exist!"
    exit 1
fi

# Extract LTK values and format them
echo "*** Extracting LTK values and formatting them from $input_file ***"
echo
declare -A ltk_map
while IFS='=' read -r mac ltk; do
    ltk_map[$mac]=$ltk
done < <(awk '
BEGIN { FS="="; OFS="" }
function format_mac(mac) {
    formatted_mac = ""
    for (i = 1; i <= length(mac); i += 2) {
        formatted_mac = formatted_mac substr(mac, i, 2)
        if (i + 2 <= length(mac)) {
            formatted_mac = formatted_mac ":"
        }
    }
    return formatted_mac
}
{
    if ($1 ~ /HKEY_LOCAL_MACHINE\\SYSTEM\\ControlSet001\\Services\\BTHPORT\\Parameters\\Keys\\[0-9a-f]{12}/) {
        mac=$1;
        sub(/.*\\/, "", mac);
        sub(/]/, "", mac);
        mac = format_mac(mac);
    }
    else if ($1 ~ /LTK/) {
        gsub(/hex:/, "", $2); # Remove hex:
        gsub(/,/, "", $2);    # Remove all commas
        print toupper(mac), "=", toupper($2); # Convert to uppercase and output
    }
}
' "$input_file")

# Debugging: Print the extracted LTK map
echo "Extracted LTK map from $input_file:"
for mac in "${!ltk_map[@]}"; do
    echo "MAC: $mac, LTK: ${ltk_map[$mac]}"
done
echo

# Get the device directory
device_dir=$(ls /var/lib/bluetooth/)
if [ -z "$device_dir" ]; then
    echo "No device directory found"
    exit 1
fi

# Construct the device directory path
device_path="/var/lib/bluetooth/$device_dir"

# Iterate over all subdirectories in the device directory
echo "*** Iterating over all subdirectories in the device directory ***"
echo
for device in $(ls "$device_path"); do
    # Skip if device does not contain a colon
    if [[ "$device" != *:* ]]; then
        continue
    fi

    # Construct the info file path
    info_file="$device_path/$device/info"

    # Check if the info file exists
    if [ ! -f "$info_file" ]; then
        echo "Info file not found: $info_file"
        continue
    fi

    # Extract the Name field
    name=$(grep -i "Name=" "$info_file" | cut -d'=' -f2)

    # Output the result
    echo "Processing device: $device"
    if [ -z "$name" ]; then
        echo "  Device Name not found in $info_file"
    else
        echo "  Device Name: $name"
    fi

    # Check if the first 8 characters of device match any key in ltk_map
    for mac in "${!ltk_map[@]}"; do
        if [[ ${device:0:8} == ${mac:0:8} ]]; then
            ltk=${ltk_map[$mac]}
            echo "  Device Address: $device, LTK: $ltk"
            
            # Replace Key= in the info file with the matched LTK
            sed -i "/\[LongTermKey/,/\[/ s/^Key=.*/Key=$ltk/" "$info_file"

            # Rename the directory to the full MAC address
            new_device_name="$mac"
            new_device_path="$device_path/$new_device_name"
            if [ "$device" == "$new_device_name" ]; then
                echo "  Directory $device already has the correct name, no need to rename."
            elif [ -d "$new_device_path" ]; then
                echo "  Directory $new_device_path already exists, skipping rename."
            else
                mv "$device_path/$device" "$new_device_path"
                echo "  Renamed directory from $device to $new_device_name"
            fi

            break
        fi
    done
    echo
done