# garage-discordbot

A bot for Jim's Garage Discord Server

## Bot Features

TBD

## API

The bot runs a FastAPI webserver in parallel to the bot, 
providing an API to interact with the bot.

The webserver defaults to port `8080`, but you can customize this
by setting the `API_PORT` environment variable.

### Endpoints
Automatically generated API documentation is available at:
- `/docs`
- `/redoc`

#### GET /healthcheck

#### GET /status

## Contributing

For details on contributing to the project, see [CONTRIBUTING.md](.github/CONTRIBUTING.md).

## ToDos

To see planned features and improvements, check out [TODO.md](.github/TODO.md).

Please submit Issues here in GitHub to track suggestions/bug fixes, etc. 
Once the initial backlog of ToDos are wrapped up, I plan to deprecate TODO.md and work off of GitHub Issues.
