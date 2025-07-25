#!/bin/bash

set -e

# Create log directory
mkdir -p /var/log/stable-diffusion

# Clone extensions
git clone https://github.com/Mikubill/sd-webui-controlnet extensions/sd-webui-controlnet && \
git clone https://github.com/Bing-su/adetailer extensions/adetailer && \
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete extensions/a1111-sd-webui-tagcomplete && \
git clone https://github.com/nonnonstop/sd-webui-3d-open-pose-editor extensions/sd-webui-3d-open-pose-editor

# Ensure permissions
chown -R sduser:sduser /opt/stable-diffusion/stable-diffusion-webui/outputs
chown -R sduser:sduser /opt/stable-diffusion/stable-diffusion-webui/log
chown -R sduser:sduser /var/log/stable-diffusion

# Start the Stable Diffusion WebUI
exec su - sduser -c "/opt/stable-diffusion/stable-diffusion-webui/webui.sh --listen --api --xformers"