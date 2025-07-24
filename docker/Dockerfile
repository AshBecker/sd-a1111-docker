FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt/stable-diffusion

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-venv wget \
    nfs-common libgl1 libglib2.0-0 \
    ufw s3fs s3cmd\
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m sduser

# Clone Stable Diffusion WebUI
RUN mkdir -p $HOME && \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $HOME/stable-diffusion-webui

WORKDIR $HOME/stable-diffusion-webui

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118 \
    python3 launch.py --exit --skip-torch-cuda-test || true && \
    rm -rf /root/.cache /home/sduser/.cache $HOME/stable-diffusion-webui/.cache

# Create output and log directories
RUN mkdir -p $HOME/stable-diffusion-webui/outputs/txt2img-images \
    $HOME/stable-diffusion-webui/outputs/img2img-images \
    $HOME/stable-diffusion-webui/outputs/extra-images \
    $HOME/stable-diffusion-webui/outputs/txt2img-grids \
    $HOME/stable-diffusion-webui/outputs/img2img-grids \
    $HOME/stable-diffusion-webui/outputs/init-images \
    $HOME/stable-diffusion-webui/log/images \
    /var/log/stable-diffusion

# Copy styles.csv (custom prompts/styles)
COPY --chown=sduser:sduser docker/styles.csv $HOME/stable-diffusion-webui/styles.csv

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy baked-in models and embeddings from build context
COPY models/ $HOME/stable-diffusion-webui/models/

# Set permissions
RUN chown -R sduser:sduser $HOME && \
    chown -R sduser:sduser /var/log/stable-diffusion

# Expose WebUI port
EXPOSE 7860

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]