#!/bin/bash

set -e

# Create log directory
mkdir -p /var/log/stable-diffusion

# Write S3 credentials (use env var for security)
if [ -n "$S3_ACCESS_KEY" ] && [ -n "$S3_SECRET_KEY" ]; then
  echo "${S3_ACCESS_KEY}:${S3_SECRET_KEY}" > /etc/passwd-s3fs
  chmod 600 /etc/passwd-s3fs
fi

# Mount S3 buckets directly to the models directories
for d in Stable-diffusion VAE Lora ControlNet VAE-approx; do
  mkdir -p /opt/stable-diffusion/stable-diffusion-webui/models/$d
  s3fs sd-files:/$d /opt/stable-diffusion/stable-diffusion-webui/models/$d \
    -o url=https://sgp1.vultrobjects.com \
    -o use_path_request_style \
    -o allow_other \
    -o nonempty \
    -o uid=$(id -u sduser) \
    -o gid=$(id -g sduser) \
    -o umask=022
done

find /opt/stable-diffusion/stable-diffusion-webui/ \
    ! -path "/opt/stable-diffusion/stable-diffusion-webui/models/Stable-diffusion/*" \
    ! -path "/opt/stable-diffusion/stable-diffusion-webui/models/VAE/*" \
    ! -path "/opt/stable-diffusion/stable-diffusion-webui/models/Lora/*" \
    ! -path "/opt/stable-diffusion/stable-diffusion-webui/models/ControlNet/*" \
    ! -path "/opt/stable-diffusion/stable-diffusion-webui/models/VAE-approx/*" \
    -exec chown sduser:sduser {} +

# Ensure permissions
chown sduser:sduser /opt/stable-diffusion/stable-diffusion-webui/models
chown -R sduser:sduser /opt/stable-diffusion/stable-diffusion-webui/outputs
chown -R sduser:sduser /opt/stable-diffusion/stable-diffusion-webui/log
chown -R sduser:sduser /var/log/stable-diffusion

# Start the Stable Diffusion WebUI
exec /opt/stable-diffusion/stable-diffusion-webui/webui.sh --listen --api --xformers