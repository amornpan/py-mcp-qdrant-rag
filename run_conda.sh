#!/bin/bash
# Run pyRAGDocs with Conda environment

# Source conda.sh to get conda command
source "$(conda info --base)/etc/profile.d/conda.sh"

# Activate the environment
conda activate mcp-rag-qdrant-1.0

# Run the server
python -m ragdocs.server "$@"
