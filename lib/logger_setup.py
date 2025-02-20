import logging
import logging.handlers
import os
import sys


def configure_logger() -> None:
    """Set up logging"""
    logger: logging.Logger = logging.getLogger()
    logging.getLogger("discord.http").setLevel(logging.INFO)

    # Define log format
    date_format: str = "%Y-%m-%d %H:%M:%S"
    formatter: logging.Formatter = logging.Formatter(
        "[{asctime}] [{levelname:<7}] {name}: {message}", date_format, style="{"
    )

    # Set up file logging
    log_dir: str = os.getenv("LOG_DIR", "logs")
    log_level_file_str: str = os.getenv("LOG_LEVEL_FILE", "INFO")
    log_level_file: int = getattr(logging, log_level_file_str)

    file_handler: logging.handlers.RotatingFileHandler = (
        logging.handlers.RotatingFileHandler(
            filename=f"{log_dir}/discord.log",
            encoding="utf-8",
            maxBytes=1024 * 1024 * 10,  # 10MB
            backupCount=5,  # Rotate through 5 files
        )
    )
    file_handler.setLevel(log_level_file)
    file_handler.setFormatter(formatter)

    logger.addHandler(file_handler)

    # Set up stdout logging
    log_level_stdout_str: str = os.getenv("LOG_LEVEL_STDOUT", "INFO")
    log_level_stdout: int = getattr(logging, log_level_stdout_str)

    stdout_handler: logging.StreamHandler = logging.StreamHandler(sys.stdout)
    stdout_handler.setLevel(log_level_stdout)
    stdout_handler.setFormatter(formatter)

    logger.addHandler(stdout_handler)
