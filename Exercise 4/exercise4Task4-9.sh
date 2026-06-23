#!/usr/bin/env bash
set -euo pipefail

#######################################
# User-configurable variables
#######################################
PVC_NAME="c1-svm0-nfs-pvc-autogrow"
PVC_NAMESPACE="default"
TRIDENT_NAMESPACE="trident"

ONTAP_CLUSTER="https://cluster1.demo.netapp.com"
ONTAP_USER="admin"
ONTAP_PASS="Netapp1!"

#######################################
# Helper functions
#######################################
fail() {
  echo "ERROR: $*" >&2
  exit 1
}

#######################################
# Get backing Kubernetes volume name
#######################################
K8S_VOLUME_NAME=$(
  kubectl get pvc -n "${PVC_NAMESPACE}" "${PVC_NAME}" \
    -o jsonpath='{.spec.volumeName}'
) || fail "Failed to get volumeName for PVC ${PVC_NAME}"

[[ -z "${K8S_VOLUME_NAME}" ]] && fail "PVC ${PVC_NAME} has no volumeName"

#######################################
# Get Trident internal volume name
#######################################
VOLNAME=$(
  kubectl get -n "${TRIDENT_NAMESPACE}" tvol "${K8S_VOLUME_NAME}" \
    -o jsonpath='{.config.internalName}'
) || fail "Failed to get Trident internalName"

[[ -z "${VOLNAME}" ]] && fail "Trident internalName not found"

#######################################
# Get ONTAP volume UUID
#######################################
VOLUUID=$(
  curl -sS -k -u "${ONTAP_USER}:${ONTAP_PASS}" \
    "${ONTAP_CLUSTER}/api/storage/volumes?name=${VOLNAME}" \
    -H "accept: application/json" |
    jq -r '.records[0].uuid'
) || fail "Failed to query ONTAP volume UUID"

[[ -z "${VOLUUID}" || "${VOLUUID}" == "null" ]] && fail "Volume UUID not found"

#######################################
# Get used space in GiB (rounded to 2 decimals)
#######################################
USED_GIB=$(
  curl -sS -k -u "${ONTAP_USER}:${ONTAP_PASS}" \
    "${ONTAP_CLUSTER}/api/storage/volumes/${VOLUUID}" \
    -H "accept: application/json" |
    jq -r '.space.used / 1024 / 1024 / 1024 * 100 | round / 100'
) || fail "Failed to retrieve volume usage"

echo "PVC:        ${PVC_NAME}"
echo "ONTAP Vol:  ${VOLNAME}"
echo "Used (GiB): ${USED_GIB}"
