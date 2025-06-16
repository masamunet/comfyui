#!/bin/bash

set -euo pipefail

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting ComfyUI extensions installation..."

# Create extensions directory
if ! mkdir -p /workspace_tmp/ComfyUI/web/extensions; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to create extensions directory" >&2
    exit 1
fi

# Change to custom_nodes directory
if ! cd /workspace_tmp/ComfyUI/custom_nodes/; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to change to custom_nodes directory" >&2
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing dynamicprompts extension..."

# Clone dynamicprompts repository
if ! git clone https://github.com/adieyal/comfyui-dynamicprompts.git; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to clone dynamicprompts repository" >&2
    exit 1
fi

# Change to dynamicprompts directory
if ! cd comfyui-dynamicprompts; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to change to dynamicprompts directory" >&2
    exit 1
fi

# Install requirements
if [ -f requirements.txt ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installing requirements..."
    if ! pip3 install -r requirements.txt; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to install requirements" >&2
        exit 1
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: requirements.txt not found, skipping pip install" >&2
fi

# Run install script
if [ -f install.py ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Running install script..."
    if ! python3 install.py; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to run install script" >&2
        exit 1
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: install.py not found, skipping install script" >&2
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ComfyUI extensions installation completed successfully"
