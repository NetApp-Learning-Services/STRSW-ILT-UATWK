#!/bin/bash

# Set the context to the source cluster
kubectl config use-context source-admin@source


echo "Deleteing SVM svmsrc in source cluster"
kubectl delete svm svmsrc


# Set the context to the destination cluster
kubectl config use-context destination-admin@destination

echo "Deleteing SVM svmdst in destination cluster"
kubectl delete svm svmdst