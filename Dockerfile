FROM python:3.11-slim

WORKDIR /app

# Install system dependencies and Node.js
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    curl \
    sqlite3 \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g prettier@3.4.2 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Create data directory and set permissions
RUN mkdir -p /data && chmod 777 /data
RUN mkdir -p /tmp && chmod 777 /tmp

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Run datagen.py first, then start the FastAPI server
CMD python3 datagen.py test@example.com && uvicorn main:app --host 0.0.0.0 --port 8000