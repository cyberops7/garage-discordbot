import logging

from fastapi import FastAPI
from pydantic import BaseModel

logger: logging.Logger = logging.getLogger(__name__)
app = FastAPI()


class HealthCheckResponse(BaseModel):
    status: str
    message: str


@app.get("/healthcheck")
async def healthcheck() -> HealthCheckResponse:
    """
    Healthcheck endpoint.
    """
    return HealthCheckResponse(status="ok", message="Bot is running")
