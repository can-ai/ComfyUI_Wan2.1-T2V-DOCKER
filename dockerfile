# Base image with CUDA 12.1
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install base system packages
RUN apt-get update && apt-get install -y \
    python3 python3-pip git git-lfs wget ffmpeg libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Symlink python3 -> python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Install Git LFS and pull model weights
RUN git lfs install

# Workdir
WORKDIR /app

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Clone Wan2.1-T2V-14B (video model, VAE, CLIP)
RUN git clone https://huggingface.co/Wan-AI/Wan2.1-T2V-14B

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start ComfyUI
CMD ["/start.sh"]
