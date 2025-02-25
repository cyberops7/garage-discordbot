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
  - [ ] `make check`
    - [x] Run linters and checkers 
    - [x] `make fix` as a fix-enabled version of `make check`
    - [ ] Compare/test between Pyre and Pyright
  - [x] `make clean`
    - [x] Clean up old Docker containers and buildx builders
    - [x] Run as a prerequisite for `make run`, `make build`
  - [x] `make deps`
    - Check that dev dependencies are installed
  - [x] `make publish`
    - [x] Make it a variant `build`, just with an extra flag to push the image
  - [x] `make run`
    - Run the bot container locally
  - [ ] `make scan`
    - [ ] Get other scanners working


- GitHub Actions
  - Submitted PRs
    - [ ] Lint/check code
    - [ ] Build image
    - [ ] Scan image
  - Accepted PRs
    - [ ] Build and publish image to ghcr


- Logging
  - [ ] JSON log formatting
  - [ ] Log to a queue handler to make logging non-blocking
  - [x] Bash logging library
  - [x] Logs in bash files (colorized)
  - [ ] Add more logging everywhere
  - [ ] Tune discord's noisy logs


- Docker
  - [ ] Investigate moving to python:3.13-alpine base image
  - [ ] Move to a `docker/` directory
  - [ ] A docker compose file


- Kubernetes
  - [ ] Create `kubernetes/` directory with manifests
  - [ ] Pull those into or from internal k3s repo (TBD)
