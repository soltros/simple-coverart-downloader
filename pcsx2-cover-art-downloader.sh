#!/bin/bash

# Set the output folder for the cover art
OUTPUT_FOLDER="$HOME/Pictures/rom-covers"

# Create output directory if it doesn't exist
if [ ! -d "$OUTPUT_FOLDER" ]; then
    mkdir -p "$OUTPUT_FOLDER"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create output directory"
        exit 1
    fi
fi

# Function to validate serial number format
validate_serial() {
    local serial=$1
    # PS2 serials typically follow patterns like SLUS-12345 or SLES-12345
    if [[ ! $serial =~ ^[A-Z]{4}-[0-9]{5}$ ]]; then
        echo "Warning: Serial format might be incorrect. Expected format: XXXX-XXXXX (e.g., SLUS-12345)"
        read -p "Continue anyway? (y/n): " confirm
        if [[ $confirm != [yY] ]]; then
            return 1
        fi
    fi
    return 0
}

# Prompt user to input the serial
while true; do
    read -p "Enter the PS2 game serial (e.g., SLUS-12345): " serial
    
    # Convert to uppercase
    serial=${serial^^}
    
    # Validate serial format
    if validate_serial "$serial"; then
        break
    else
        echo "Please try again."
    fi
done

# Construct the URL
url="https://raw.githubusercontent.com/xlenore/ps2-covers/refs/heads/main/covers/default/$serial.jpg"

# Download the cover art using wget
echo "Downloading cover art for $serial..."
if wget --quiet --show-progress --tries=3 --timeout=10 -O "$OUTPUT_FOLDER/$serial.jpg" "$url"; then
    echo "✓ Successfully downloaded cover art for $serial"
    echo "Saved to: $OUTPUT_FOLDER/$serial.jpg"
    exit 0
else
    echo "❌ Failed to download cover art for $serial after 3 attempts"
    echo "Please check:"
    echo "  - Your internet connection"
    echo "  - The serial number is correct"
    echo "  - The cover exists in the repository"
    exit 1
fi
