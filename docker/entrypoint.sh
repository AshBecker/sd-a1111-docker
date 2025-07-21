#!/bin/bash

# Create log directory
mkdir -p /var/log/stable-diffusion

# Start the Stable Diffusion WebUI
exec /opt/stable-diffusion/stable-diffusion-webui/webui.sh --listen --api --xformers --ckpt-dir=/mnt/nfs