"""DiscordBot class"""

import logging

import discord

logger: logging.Logger = logging.getLogger(__name__)


class DiscordBot(discord.Client):
    """Discord bot class"""

    async def on_ready(self) -> None:
        """Called when the bot is ready"""
        logger.info("We have logged in as %s", self.user)

    async def on_message(self, message: discord.Message) -> None:
        """Called when a message is received"""
        # Ignore messages from the bot itself
        if message.author == self.user:
            return

        # Respond to messages starting with "hello"
        if message.content.lower().startswith("hello"):
            logger.info("Received 'hello' from %s", message.author)
            await message.channel.send("Hello")
            return
