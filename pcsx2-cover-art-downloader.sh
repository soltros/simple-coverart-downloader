#!/bin/bash

# Set the path to the local database CSV file
DB_PATH="$HOME/scripts/ps2-game-database.csv"

# Set the path to the directory containing the PS2 ISOs
ISO_DIR="/mnt/storage/ROMS/PS2"

# Set the output folder for the cover art
OUTPUT_FOLDER="$HOME/Pictures/rom-covers"

# Scan the ISO directory and download cover art for each ISO
for filename in "$ISO_DIR"/*.iso; do
  # Extract the game title from the ISO filename
  game_title="${filename%.iso}"
  game_title="${game_title##*/}"
  
  # Find the serial code in the database
  serial=$(grep -i "$game_title" "$DB_PATH" | cut -d';' -f1)
  
  if [ -n "$serial" ]; then
    url="https://raw.githubusercontent.com/xlenore/ps2-covers/main/covers/default/$serial.jpg"
    curl -s -o "$OUTPUT_FOLDER/$serial.jpg" "$url"
    if [ $? -eq 0 ]; then
      echo "Cover art downloaded for $serial"
    else
      echo "Failed to download cover art for $serial"
    fi
  else
    echo "No match found in database for $game_title"
  fi
done
