### Features

---
- [ ] DM new members on join
- [ ] Link resources for common topics
  - Slash commands?
  - Buttons/dropdowns?

### Infra / Quality

---
- Documentation
  - CONTRIBUTING
    - [ ] Pre-commit hooks
    - [ ] Using the DiscordBot class
    - [ ] Add new modules into `lib/`
    - Testing
      - [ ] How to run locally
  - README
    - [ ] Bot features
    - [ ] Brief architecture overview
    - [ ] Link to discord.py documentation
    - [ ] While tailored to Jim's Garage and my own dev environment, feel free to fork, etc.
    - [ ] How to run your own instance of the bot - docker, kubernetes
  
  
- Makefile / Core Functions
  - `make check`
    - [x] Run linters and checkers 
    - [x] `make fix` as a fix-enabled version of `make check`
    - [x] Add yaml linting (yamllint)
    - [ ] Compare/test between Pyre and Pyright
  - `make clean`
    - [x] Clean up old Docker containers and buildx builders
    - [x] Run as a prerequisite for `make run`, `make build`
  - `make deps`
    - Check that dev dependencies are installed
  - `make publish`
    - [x] Make it a variant `build`, just with an extra flag to push the image
  - `make run`
    - Run the bot container locally
  - `make scan`
    - [ ] Get other scanners working
  - [ ] Add ARG information to target help comments


- GitHub Actions
  - Submitted PRs
    - [ ] Lint/check code
    - [ ] Build image
    - [ ] Scan image
  - Accepted PRs
    - [ ] Build and publish image to ghcr


- Pre-commit Hooks
  - [x] Ruff (check + format)
  - [ ] Pyre
    - There are some recent fixes to the pre-commit-hooks, 
      but there has not been a release yet that includes them
  - [x] Trivy fs
  - [x] uv lock
  - [x] yamllint


- Logging
  - [ ] Logger config read from yaml/JSON file
  - [ ] JSON log formatting
  - [ ] Log to a queue handler to make logging non-blocking
  - [x] Bash logging library
  - [x] Logs in bash files (colorized)
  - [ ] Add more logging everywhere
  - [ ] Tune discord's noisy logs


- Docker
  - [ ] Write a healthcheck script (from discord.ext import tasks)
  - [ ] Investigate moving to python:3.13-alpine base image
  - [x] Move to a `docker/` directory
  - [x] A docker compose file


- Kubernetes
  - [ ] Create `kubernetes/` directory with manifests
  - [ ] Pull those into or from internal k3s repo (TBD)
  - [ ] Trivy config scanning: https://trivy.dev/v0.57/docs/scanner/misconfiguration/


- Unit Testing
  - [ ] Figure out what testing makes sense
