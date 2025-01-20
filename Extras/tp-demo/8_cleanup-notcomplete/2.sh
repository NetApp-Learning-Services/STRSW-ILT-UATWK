#!/bin/bash

SRCAPPVAULT="c1-svmsrc-s3-av"
DSTAPPVAULT="c2-svmdst-s3-av"
APPNAMESPACE="mywordpressapp"
DSTNAMESPACE="mywordpressapp-dst"
SRCSECRET="c1-svmsrc-backend-secret"
DSTSECRET="c2-svmdst-backend-secret"
SRCS3SECRET="gateway-s3-src"
DSTS3SECRET="gateway-s3-dst"
SRCBACKEND="c1-svmsrc-nfs-custom-tbc"
DSTBACKEND="c2-svmdst-nfs-custom-tbc"
SC="nfs-custom-sc"
SRCSVM="svmsrc"
DSTSVM="svmdst"

# Set the context to the destination cluster
kubectl config use-context destination-admin@destination

echo "Deleting $RCAPPVAULT appvault"
kubectl -n trident-protect delete appvault $SRCAPPVAULT

echo "Deleting $DSTAPPVAULT appvault"
kubectl -n trident-protect delete appvault $DSTAPPVAULT

echo "Deleting $DSTNAMESPACE namespace"
kubectl delete ns $DSTNAMESPACE

echo "Deleting $SRCS3SECRET secret"
kubectl -n trident-protect delete secret $SRCS3SECRET

echo "Deleting $DSTS3SECRET secret"
kubectl -n trident-protect delete secret $DSTS3SECRET

echo "Deleting $DSTBACKEND backed"
kubectl -n trident delete tbc $DSTBACKEND

echo "Deleting $DSTSECRET secret"
kubectl -n trident delete secret $DSTSECRET

echo "Deleting $SC storageclass"
kubectl delete sc $SC

echo "Deleting SVM $DSTSVM in destination cluster"
kubectl -n gateway-system delete svm $DSTSVM

# Set the context to the source cluster
kubectl config use-context source-admin@source

echo "Deleting $RCAPPVAULT appvault"
kubectl -n trident-protect delete appvault $SRCAPPVAULT

echo "Deleting $SRCS3SECRET secret"
kubectl -n trident-protect delete secret $SRCS3SECRET

echo "Deleting $DSTS3SECRET secret"
kubectl -n trident-protect delete secret $DSTS3SECRET

echo "Deleting $APPNAMESPACE namespace"
kubectl delete ns $APPNAMESPACE

echo "Deleting $SRCBACKEND backed"
kubectl -n trident delete tbc $SRCBACKEND

echo "Deleting $SRSECRET secret"
kubectl -n trident delete secret $SRCSECRET

echo "Deleting $SC storageclass"
kubectl delete sc $SC

echo "Deleting SVM $SRCSVM in source cluster"
kubectl -n gateway-system delete svm $SRCSVM