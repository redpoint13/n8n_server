# Use an official NVIDIA base with CUDA support
FROM nvidia/cuda:12.2.0-base-ubuntu22.04

USER root

# Install Python, pip, Node.js, and curl
RUN apt-get update && apt-get install -y curl python3 python3-pip python3-venv \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install the ultra-fast 'uv' python package installer to replicate the n8nio/runners setup
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Install the n8n task runner logic
RUN npm install -g @n8n/task-runner

# Install your project's python modules
RUN uv pip install --system pandas pdfplumber

# Start the python task runner
CMD ["n8n-task-runner"]
