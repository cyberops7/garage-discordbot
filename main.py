import logging
import logging.handlers
import os

import discord
import dotenv

from lib.bot import DiscordBot
from lib.logger_setup import configure_logger

# TODO: Dockerfile
# TODO: set up Makefile (?)
# TODO: run isort, mypy, and ruff on build
# TODO: set up GitHub Actions for building and publishing the image


def main() -> None:
    # Load .env into system ENV
    dotenv.load_dotenv()

    # Set up logging
    configure_logger()
    logger: logging.Logger = logging.getLogger(__name__)

    # Retrieve bot token
    bot_token: str = os.getenv("BOT_TOKEN")
    if not bot_token:
        logger.error("BOT_TOKEN is not set")
        exit(1)

    # Initialize the bot
    logger.info("Initializing bot...")
    intents: discord.Intents = discord.Intents.default()
    intents.message_content = True  # NOQA
    bot: DiscordBot = DiscordBot(intents=intents)

    # Run the bot
    bot.run(bot_token, log_handler=None)


if __name__ == "__main__":
    main()
