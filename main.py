"""Driver for the garage-discordbot project"""

import logging.handlers
import os
import sys
from logging import Logger
from threading import Thread

import discord
import uvicorn
from discord import Intents
from dotenv import load_dotenv

from lib.api import app
from lib.bot import DiscordBot
from lib.logger_setup import configure_logger
from lib.utils import validate_port

logger: Logger = logging.getLogger(__name__)


def start_fastapi_server(port: int = 8080) -> None:
    """
    Start the FastAPI server
    """
    uvicorn.run(app, host="0.0.0.0", port=port, log_config=None)  # noqa: S104


def main() -> None:
    """Main driver function"""
    # Load .env contents into system ENV
    # !! Vars defined in .env will override any default env var values !!
    load_dotenv(override=True)

    # Set up logging
    configure_logger()

    # Validate the port number
    api_port: int | None = None
    try:
        api_port = int(os.getenv("API_PORT", "8080"))
        validate_port(api_port)
    except ValueError:
        msg = f"API_PORT is not a valid port integer: {os.getenv('API_PORT')}"
        logger.exception(msg)
    if not api_port:
        sys.exit(1)

    # Run health check in a separate thread
    api_thread = Thread(
        target=start_fastapi_server, daemon=True, kwargs={"port": api_port}
    )
    api_thread.start()

    # Retrieve bot token
    logger.info("Retrieving bot token...")
    if not (bot_token := os.getenv("BOT_TOKEN")):
        logger.error("BOT_TOKEN is not set")
        sys.exit(1)

    # Initialize the bot
    logger.info("Initializing bot...")
    intents: Intents = discord.Intents.all()
    bot: DiscordBot = DiscordBot(intents=intents)

    # Run the bot
    bot.run(bot_token, log_handler=None)


if __name__ == "__main__":
    main()
