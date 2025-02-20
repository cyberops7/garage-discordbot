import logging

import discord

logger: logging.Logger = logging.getLogger(__name__)


class DiscordBot(discord.Client):
    async def on_ready(self) -> None:
        logger.info(f"We have logged in as {self.user}")

    async def on_message(self, message) -> None:
        # Ignore messages from the bot itself
        if message.author == self.user:
            return

        # Respond to messages starting with "hello"
        if message.content.lower().startswith("hello"):
            logger.info("Received 'hello' from %s", message.author)
            await message.channel.send("Hello")
            return
