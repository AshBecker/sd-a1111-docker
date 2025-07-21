FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/opt/stable-diffusion

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    nfs-common \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m sduser

# Clone Stable Diffusion WebUI
RUN mkdir -p $HOME && \
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $HOME/stable-diffusion-webui

WORKDIR $HOME/stable-diffusion-webui

# Clone extensions (add/remove as needed)
RUN git clone https://github.com/Mikubill/sd-webui-controlnet extensions/sd-webui-controlnet && \
    git clone https://github.com/Bing-su/adetailer extensions/adetailer && \
    git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete extensions/a1111-sd-webui-tagcomplete && \
    git clone https://github.com/dvruette/sd-webui-fabric extensions/sd-webui-fabric && \
    git clone https://github.com/some9000/StylePile extensions/StylePile && \
    git clone https://github.com/nonnonstop/sd-webui-3d-open-pose-editor extensions/sd-webui-3d-open-pose-editor

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    pip3 install torch==2.0.0+cu113 torchvision==0.15.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

# (Optional) Pre-install WebUI dependencies for faster startup
RUN python3 launch.py --exit

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set permissions
RUN chown -R sduser:sduser $HOME

# Expose WebUI port
EXPOSE 7860

# Switch to non-root user
USER sduser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]