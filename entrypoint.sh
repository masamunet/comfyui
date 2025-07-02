#!/bin/bash

set -euo pipefail

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting entrypoint script..."

# Check if /workspace_tmp exists
if [ -d "/workspace_tmp" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Found /workspace_tmp, copying contents to /workspace..."
    
    # Create workspace directory if it doesn't exist
    mkdir -p /workspace
    
    # Move all contents from /workspace_tmp to /workspace
    if [ "$(ls -A /workspace_tmp 2>/dev/null)" ]; then
        if ! mv /workspace_tmp/* /workspace/ 2>/dev/null; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to move files from /workspace_tmp to /workspace" >&2
            exit 1
        fi
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successfully moved files to /workspace"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] /workspace_tmp is empty, nothing to move"
    fi
    
    # Remove /workspace_tmp directory
    if ! rm -rf /workspace_tmp; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: Failed to remove /workspace_tmp directory" >&2
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed /workspace_tmp directory"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] /workspace_tmp not found, skipping file copy"
fi

cd /
git clone https://github.com/Hearmeman24/CivitAI_Downloader.git
cd CivitAI_Downloader

# Check if CIVITAI_API_KEY is set
if [ ! -z "$CIVITAI_API_KEY" ]; then
    # Check if CIVITAI_LORA_IDS is set
    if [ ! -z "$CIVITAI_LORA_IDS" ]; then
        # Create loras directory if it doesn't exist
        mkdir -p /workspace/ComfyUI/models/loras
        
        # Split CIVITAI_LORA_IDS by comma and iterate
        IFS=',' read -ra LORA_IDS <<< "$CIVITAI_LORA_IDS"
        for lora_id in "${LORA_IDS[@]}"; do
            python3 download.py -t "$CIVITAI_API_KEY" -m "$lora_id" -o /workspace/ComfyUI/models/loras > /dev/null 2>&1
        done
    fi
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Entrypoint script completed successfully"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing command: $*"

# Execute the CMD passed as arguments
exec "$@"
