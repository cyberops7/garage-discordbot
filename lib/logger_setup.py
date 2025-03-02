"""Logging library - configure logging from a yaml config file"""

import atexit
import logging
import logging.config
import logging.handlers
from logging import Logger
from pathlib import Path

import yaml

from lib import config_parser

# change this to DEBUG if debugging logger initialization
logging.basicConfig(level=logging.INFO)
logger: Logger = logging.getLogger(__name__)


def configure_logger(file_path: str = "conf/logger.yaml") -> None:
    """Set up logging using a YAML file"""
    logger.info("Loading logging configuration from YAML file...")

    success: bool = False
    try:
        yaml_path = Path(file_path)
        with Path.open(yaml_path, encoding="utf-8") as yaml_file:
            try:
                yaml_config = yaml.safe_load(yaml_file)
                logger.debug("Read YAML config: %s", yaml_config)
                yaml_config_resolved = config_parser.resolve_values(yaml_config)
                logger.debug("Resolved YAML config: %s", yaml_config_resolved)
                logging.config.dictConfig(yaml_config_resolved)
                logger.info("Logging configuration loaded from YAML file.")
                logger.debug("Logging configuration: %s", yaml_config_resolved)

                # The queue handler
                logger.info("Starting queue handler listener...")
                queue_handler: logging.Handler | None = logging.getHandlerByName(
                    "queue"
                )
                if queue_handler is not None:
                    listener = getattr(queue_handler, "listener", None)
                    if listener is not None:
                        listener.start()
                        atexit.register(listener.stop)

                success = True
            except yaml.YAMLError:
                logger.exception("Error parsing YAML file.")
            except (ValueError, TypeError, KeyError, AttributeError):
                logger.exception("Error in logging configuration.")
    except (FileNotFoundError, PermissionError, IsADirectoryError, OSError):
        logger.exception("Error reading logging configuration file.")
    if not success:
        # Apply basic logging as a fallback
        logging.basicConfig(level=logging.DEBUG)
        logger.info("Default logging configuration applied.")
