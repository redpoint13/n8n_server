# Use the official n8n task runners image which natively connects to n8n
FROM n8nio/runners

USER root

# The n8n runners image uses 'uv' for incredibly fast python package installation
RUN uv pip install --system pandas pdfplumber

# Switch back to the default runner user
USER runner

# Tell the runner image to start the python launcher
CMD ["python"]
