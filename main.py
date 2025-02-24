"""Driver for the garage-discordbot project"""

import logging
import logging.handlers
import os
import sys
from logging import Logger

import discord
from discord import Intents
from dotenv import load_dotenv

from lib.bot import DiscordBot
from lib.logger_setup import configure_logger


def main() -> None:
    """Main driver function"""
    # Load .env contents into system ENV
    load_dotenv()

    # Set up logging
    configure_logger()
    logger: Logger = logging.getLogger(__name__)

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
