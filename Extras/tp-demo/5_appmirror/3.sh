#!/bin/bash

# Switch kubectl context to source-admin@source
kubectl config use-context source-admin@source

# Get the UUID of the application 'mywordpressapp' in the 'trident-protect' namespace
uuid = kubectl -n trident-protect get applications mywordpressapp -o "jsonpath={.metadata.uid}"

# Define the file to be modified
file_path="7.yaml"

# Use sed to replace 'change_me' with the value of the variable
sed -i "s/change_me/$uuid/g" "$file_path"
