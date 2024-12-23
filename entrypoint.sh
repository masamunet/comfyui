#!/bin/bash

# Check if /workspace_tmp exists
if [ -d "/workspace_tmp" ]; then
    # Move all contents from /workspace_tmp to /workspace
    mv /workspace_tmp/* /workspace/
    # Remove /workspace_tmp directory
    rm -rf /workspace_tmp
fi


# Execute the CMD passed as arguments
exec "$@"
