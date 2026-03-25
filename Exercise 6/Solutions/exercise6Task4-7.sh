#!/bin/bash

# Switch kubectl context to source-admin@source
kubectl config use-context source-admin@source

# Get the UUID of the application 'myredisapp' in the 'trident-protect' namespace
uuid=$(kubectl -n myredisapp get applications myredisapp -o jsonpath='{.metadata.uid}')

# Define the file to be modified
file_path="exercise6Task4-7.yaml"

# Use sed to replace 'change_me' with the value of the variable
sed -i "s/change_me/$uuid/g" "$file_path"

# Switch kubectl context to destination-admin@destination
kubectl config use-context destination-admin@destination
