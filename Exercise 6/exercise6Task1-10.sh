#!/bin/bash

# This script has been written for this exercise environment
# and is not intended to be used in a production environment
# Execute by: ./exercise6Task1-10.sh

# --- Configuration ---
DESTINATION_CONTEXT="destination-admin@destination"
# SSH Password - Use single quotes to treat '!' literally.
SSHPASS='Netapp1!'

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Helper Functions ---
# Function to print a step and its result
execute_step() {
    local description="$1"
    local command="$2"

    printf "    - %-60s" "$description"
    # Execute the command, redirecting all output to /dev/null
    if eval "$command" &> /dev/null; then
        printf "[${GREEN}  OK  ${NC}]\n"
    else
        printf "[${RED}FAILED${NC}]\n"
    fi
}

# --- Dependency Check ---
for cmd in sshpass kubectl; do
    if ! command -v "$cmd" &> /dev/null; then
        # Print error message to standard error
        echo -e "${RED}'$cmd' could not be found. Please install it first.${NC}" >&2
        exit 1
    fi
done


# --- Dynamic Node Discovery ---
echo -e "${BLUE}### Discovering Worker Nodes ###${NC}"

# This function prints status updates to STDERR and node names to STDOUT
get_worker_nodes() {
    local context="$1"
    local nodes
    
    # Check if context exists. Note the '>&2' which sends this output to standard error.
    if ! kubectl config get-contexts "$context" &> /dev/null; then
        printf "    - Querying context: %-40s [${YELLOW}SKIPPED${NC}] (Context not found)\n" "$context" >&2
        return
    fi
    
    # Get nodes from the valid context
    nodes=$(kubectl --context="$context" get nodes -l '!node-role.kubernetes.io/control-plane,!node-role.kubernetes.io/master' -o jsonpath='{range .items[*]}{.metadata.name}{" "}{end}' 2>/dev/null)
    
    if [ -n "$nodes" ]; then
        # Print status to standard error
        printf "    - Querying context: %-40s [${GREEN}  OK  ${NC}] (Found nodes)\n" "$context" >&2
        # Print the actual node data to standard output
        echo "$nodes"
    else
        # Print status to standard error
        printf "    - Querying context: %-40s [${YELLOW}SKIPPED${NC}] (No worker nodes found)\n" "$context" >&2
    fi
}

# Capture ONLY the standard output (the node names) from the function calls
ALL_NODES="$(get_worker_nodes "$DESTINATION_CONTEXT")"

# Create the array from the clean list of nodes
SERVERS=($ALL_NODES)

# --- Verification and Main Loop ---

# Check if any servers were found
if [ ${#SERVERS[@]} -eq 0 ]; then
    echo -e "\n${RED}### No worker nodes found in the specified contexts. Exiting. ###${NC}\n" >&2
    exit 1
fi

# DEBUG: Print the exact nodes that were found and will be configured.
echo -e "\n${BLUE}--> Discovery complete. Found ${#SERVERS[@]} nodes to configure:${NC}"
echo -e "${CYAN}${SERVERS[*]}${NC}"


for server in "${SERVERS[@]}"; do
    echo -e "\n${BLUE}### Configuring Server: $server ###${NC}"

    execute_step "Copying multipath.conf" \
        "sshpass -p \"$SSHPASS\" scp -o 'StrictHostKeyChecking=no' multipath.conf root@$server:/etc/multipath.conf"

    execute_step "Enabling iscsid and multipathd services" \
        "sshpass -p \"$SSHPASS\" ssh root@$server 'sudo systemctl enable --now iscsid multipathd'"

    execute_step "Restarting multipathd service" \
        "sshpass -p \"$SSHPASS\" ssh root@$server 'sudo service multipathd restart'"

    execute_step "Reading iSCSI initiator name" \
        "sshpass -p \"$SSHPASS\" ssh root@$server 'cat /etc/iscsi/initiatorname.iscsi'"

    execute_step "Loading nvme-tcp kernel module" \
        "sshpass -p \"$SSHPASS\" ssh root@$server 'sudo modprobe nvme-tcp'"

    execute_step "Reading NVMe host NQN" \
        "sshpass -p \"$SSHPASS\" ssh root@$server 'cat /etc/nvme/hostnqn'"
done

echo -e "\n${GREEN}### Script finished successfully on all discovered nodes. ###${NC}\n"
