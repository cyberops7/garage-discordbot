#!/usr/bin/env bash

uv sync --frozen --no-cache
uv run pytest
