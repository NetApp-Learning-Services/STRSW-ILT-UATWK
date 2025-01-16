#!/bin/bash

# App
APPNAMESPACE="mywordpressapp"
APPNAME="mywordpressapp"

# Switch kubectl context to source-admin@source
kubectl config use-context source-admin@source

# Get the UUID of the application $APPNAME in the $APPNAMESPACE namespace
UUID=$(kubectl -n $APPNAMESPACE get applications $APPNAME -o "jsonpath={.metadata.uid}")

# Define the file to be modified
file_path="7.yaml"

# Use sed to replace 'change_me' with the value of the variable
sed -i "s/change_me/$UUID/g" "$file_path"

echo "Update $file_path file with the UUID of the application $APPNAME in the $APPNAMESPACE namespace" 
