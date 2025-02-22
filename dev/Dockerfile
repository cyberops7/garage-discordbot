# Stage 1: Build Stage
FROM python:3.13-slim-bookworm
LABEL org.opencontainers.image.source=https://github.com/cyberops7/garage-discordbot

# Set up default env vars
ENV APP_HOME=/app \
    LOG_DIR=/app/logs \
    LOG_LEVEL_FILE=INFO \
    LOG_LEVEL_STDOUT=INFO \
    PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Update base packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install `uv`
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create application directory and set permissions
RUN addgroup --system appgroup && \
    adduser --system appuser --ingroup appgroup && \
    mkdir -p $LOG_DIR && \
    chown -R appuser:appgroup $APP_HOME

# Set working directory
WORKDIR $APP_HOME

# Copy project files
COPY ./ $APP_HOME

# Create the venv and install runtime dependencies
RUN uv sync --frozen --no-cache --no-dev

# Switch to non-root user
USER appuser

# Run the bot
CMD ["uv", "run", "main.py"]
