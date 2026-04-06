#!/usr/bin/env bash
set -euo pipefail

#######################################
# User-configurable variables
#######################################
PVC_NAMESPACE="default"
POD_LABEL_SELECTOR="app=nfs-autogrow-web"
TARGET_FILE="/data/random"

# Amount of data to generate (MiB)
GENERATE_MIB=1400

#######################################
# Helper functions
#######################################
fail() {
  echo "ERROR: $*" >&2
  exit 1
}

#######################################
# Find a pod using the PVC
#######################################
POD_NAME=$(
  kubectl get pod -n "${PVC_NAMESPACE}" \
    -l "${POD_LABEL_SELECTOR}" \
    -o jsonpath='{.items[0].metadata.name}'
) || fail "Failed to locate pod"

[[ -z "${POD_NAME}" ]] && fail "No pod found matching label ${POD_LABEL_SELECTOR}"

#######################################
# Generate data inside the PVC
#######################################
echo "Generating ${GENERATE_MIB}MiB in pod ${POD_NAME}..."

kubectl exec -n "${PVC_NAMESPACE}" "${POD_NAME}" -- sh -c "
  dd if=/dev/urandom \
     of=${TARGET_FILE} \
     bs=1M \
     count=${GENERATE_MIB}
"

echo "Data generation complete."
