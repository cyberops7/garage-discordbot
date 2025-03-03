import logging

import uvicorn
from discord import ClientUser
from fastapi import FastAPI, Request
from pydantic import BaseModel

from lib.bot import DiscordBot

logger: logging.Logger = logging.getLogger(__name__)
app = FastAPI()  # Create the FastAPI app


async def start_fastapi_server(bot: DiscordBot, port: int = 8080) -> None:
    """
    Start the FastAPI server using asyncio and provide the bot instance
    to the API
    """
    # Store the bot instance in FastAPI's state object
    app.state.bot = bot

    config = uvicorn.Config(app, host="0.0.0.0", port=port, log_config=None)  # noqa: S104
    server = uvicorn.Server(config)
    await server.serve()


class HealthCheckResponse(BaseModel):
    status: str
    message: str


@app.get("/healthcheck")
async def healthcheck(request: Request) -> HealthCheckResponse:
    """
    Healthcheck endpoint that uses the Discord bot instance to check readiness.
    """
    bot = request.app.state.bot
    if bot.is_ready():
        return HealthCheckResponse(status="ok", message="Bot is running and ready")
    return HealthCheckResponse(status="not_ready", message="Bot is not ready")


class StatusResponse(BaseModel):
    latency: float
    is_ready: bool
    user: str


@app.get("/status")
async def status(request: Request) -> StatusResponse:
    bot = request.app.state.bot
    latency: float = bot.latency
    is_ready: bool = bot.is_ready()
    user: str = str(bot.user) if isinstance(bot.user, ClientUser) else "Unknown"
    return StatusResponse(
        latency=latency,
        is_ready=is_ready,
        user=user,
    )
