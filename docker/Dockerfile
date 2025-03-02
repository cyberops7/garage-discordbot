# Stage 1: Build Stage
FROM python:3.13-alpine
LABEL org.opencontainers.image.source=https://github.com/cyberops7/garage-discordbot

# Set up default env vars
ENV API_PORT=8080 \
    APP_HOME=/app \
    LOG_DIR=/app/log \
    LOG_FILE=bot.log \
    LOG_LEVEL_FILE=INFO \
    LOG_LEVEL_STDOUT=INFO \
    PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Update base packages and install Alpine dependencies
RUN apk -U upgrade --no-cache && \
    apk add --no-cache \
        bash

# Install `uv`
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy project files
COPY ./ $APP_HOME

# Create application directory and set permissions
RUN addgroup --system appgroup && \
    adduser --system appuser --ingroup appgroup --home $APP_HOME && \
    mkdir -p $LOG_DIR && \
    chown -R appuser:appgroup $APP_HOME

# Set working directory
WORKDIR $APP_HOME

# Switch to non-root user
USER appuser

# Create the venv and install runtime dependencies
RUN uv sync --frozen --no-cache --no-dev

# Run the bot
CMD ["uv", "run", "--no-dev", "main.py"]

# Placeholder healthcheck until a real one is ready
HEALTHCHECK CMD echo "Placeholder health check" || exit 0
