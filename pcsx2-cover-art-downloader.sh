#!/bin/bash

# Set the output folder for the cover art
OUTPUT_FOLDER="$HOME/Pictures/rom-covers"

# Prompt user to input the serial
read -p "Enter the serial: " serial

# Construct the URL
url="https://raw.githubusercontent.com/xlenore/ps2-covers/main/covers/default/$serial.jpg"

# Download the cover art
curl -s -o "$OUTPUT_FOLDER/$serial.jpg" "$url"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Cover art downloaded for $serial"
else
  echo "Failed to download cover art for $serial"
fi
