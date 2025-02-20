# Stage 1: Build Stage
FROM python:3.12-slim as builder

# Set working directory for the build stage
WORKDIR /app

# Install system dependencies for Poetry and builds
RUN apt-get update && \
    apt-get install -y --no-cache --no-install-recommends \
      build-essential \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# Copy the pyproject.toml and poetry.lock files
COPY pyproject.toml poetry.lock ./

# Install dependencies WITHOUT creating a virtual environment
RUN poetry config virtualenvs.create false && \
    poetry install --no-root --without dev

# Stage 2: Final Runtime Stage
FROM python:3.12-slim

# Set up default env vars
ENV BOT_TOKEN=""
ENV LOG_DIR=log
ENV LOG_LEVEL_FILE=INFO
ENV LOG_LEVEL_STDOUT=INFO

# Set working directory for the runtime stage
WORKDIR /app

# Set up application files/directory
COPY main.py lib/ ./
RUN mkdir /app/logs

# Copy only the installed dependencies and required files from the builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Run the application
CMD ["python", "your_app.py"]