#!/bin/bash

echo "############################################"
echo "###          tridentctl install          ###"
echo "############################################"

# Define the tar file, file location within the tar, and destination directory
DEST_DIR="/usr/local/bin"
TAR_FILE="../../../Exercise 2/trident-installer-24.10.0.tar.gz"
FILE_LOCATION="trident-installer/"
FILE_TO_EXTRACT="tridentctl"

# Extract the specific file from the tar archive
tar --strip-components=1 -xvf "$TAR_FILE" -C "." "$FILE_LOCATION$FILE_TO_EXTRACT" 

# Move the extracted file to the destination directory
sudo mv "$FILE_TO_EXTRACT" "$DEST_DIR"

# Make the file executable
chmod +x "$DEST_DIR/$FILE_TO_EXTRACT"

echo "File $FILE_TO_EXTRACT has been extracted, moved to $DEST_DIR, and made executable."