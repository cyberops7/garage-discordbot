# Stage 1: Build Stage
FROM python:3.13-slim
LABEL org.opencontainers.image.source=https://github.com/cyberops7/garage-discordbot

# Set up default env vars
ENV LOG_DIR=logs
ENV LOG_LEVEL_FILE=INFO
ENV LOG_LEVEL_STDOUT=INFO

# Update base packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV PATH="/root/.local/bin:$PATH"

# Copy project files and set up log directory
COPY ./ /app
RUN mkdir /app/logs

# Set working directory for the build stage
WORKDIR /app

# Create the venv and install dependencies
RUN uv sync --frozen --no-cache

# Run the bot
CMD ["uv", "run", "main.py"]
