FROM python:3.11

WORKDIR /app

# Update pip and install system dependencies that might be needed
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    && pip install --upgrade pip setuptools wheel \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the application port (matching docker-compose)
EXPOSE 8000

# Set environment variables for database connection
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_NAME=postgres
ENV DB_USER=postgres
ENV DB_PASSWORD=mysecretpassword

# Set path to LLM configuration file
ENV LLM_CONFIG_PATH=/app/configs/llm_config.yaml

# AWS credentials for Bedrock (set these to your actual values)
ENV AWS_ACCESS_KEY_ID=your_access_key_here
ENV AWS_SECRET_ACCESS_KEY=your_secret_key_here
ENV AWS_DEFAULT_REGION=us-east-1

# Run the Streamlit application
CMD ["streamlit", "run", "ui/streamlit_ui.py", "--server.address", "0.0.0.0", "--server.port", "8000"]