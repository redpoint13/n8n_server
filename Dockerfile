# Use NVIDIA CUDA base
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

USER root

# 1. Install System Dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl python3 python3-pip python3-venv build-essential \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Create the node user and home directory
RUN useradd -m -u 1000 node
WORKDIR /home/node

# 3. Install 'uv' and n8n packages
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:/home/node/.local/bin:${PATH}"

RUN npm install -g n8n @n8n/task-runner

# 4. Install Python packages (as root to use --system, or as node user)
RUN uv pip install --system pandas pdfplumber

# 5. Switch to node user for security
USER 1000

# 6. Execute Task Runner
# Note: Using 'n8n-task-runner' binary is cleaner than the direct path
CMD ["n8n-task-runner"]