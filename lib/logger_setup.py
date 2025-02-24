"""Logging library"""

import logging
import os
import sys
from logging import Formatter, Logger, StreamHandler
from logging.handlers import RotatingFileHandler
from typing import TextIO


def configure_logger() -> None:
    """Set up logging"""
    logger = create_logger()
    logging.getLogger("discord.http").setLevel(logging.INFO)

    # Define log format
    formatter = create_formatter()

    # Set up file logging
    logger.addHandler(create_file_handler(formatter))

    # Set up stdout logging
    logger.addHandler(create_stdout_handler(formatter))


def create_logger() -> Logger:
    """Create a logger"""
    logger: Logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    return logger


def create_file_handler(formatter: Formatter) -> RotatingFileHandler:
    """Create a file handler with a provided formatter"""
    log_dir: str = os.getenv("LOG_DIR", "logs")
    log_level_file_str: str = os.getenv("LOG_LEVEL_FILE", "INFO")
    log_level_file: int = getattr(logging, log_level_file_str)

    file_handler: RotatingFileHandler = RotatingFileHandler(
        filename=f"{log_dir}/discord.log",
        encoding="utf-8",
        maxBytes=1024 * 1024 * 10,  # 10MB
        backupCount=5,
    )
    file_handler.setLevel(log_level_file)
    file_handler.setFormatter(formatter)
    return file_handler


def create_formatter() -> Formatter:
    """Create a log formatter"""
    return Formatter(
        "[{asctime}] [{levelname:<7}] {name}: {message}",
        "%Y-%m-%d %H:%M:%S",
        style="{",
    )


def create_stdout_handler(formatter: Formatter) -> StreamHandler[TextIO]:
    """Create a stdout (stream) handler with a provided formatter"""
    log_level_stdout_str: str = os.getenv("LOG_LEVEL_STDOUT", "INFO")
    log_level_stdout: int = getattr(logging, log_level_stdout_str)

    stdout_handler: StreamHandler[TextIO] = StreamHandler(sys.stdout)
    stdout_handler.setLevel(log_level_stdout)
    stdout_handler.setFormatter(formatter)
    return stdout_handler
