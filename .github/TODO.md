### Features

---
- [ ] DM new members on join
- [ ] Link resources for common topics
  - Slash commands?
  - Buttons/dropdowns?

### Infra / Quality

---
- [ ] README
- [ ] CONTRIBUTING
- [ ] `make check`
  - Run linters and checkers 
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
- [x] Bash logging library
- GitHub Actions
  - [ ] PRs
    - [ ] Lint/check code
    - [ ] Build image
    - [ ] Scan image
  - [ ] Accepted PRs
    - [ ] Build and publish image to ghcr
- Logging
  - [ ] Logs in bash files (colorized)
  - [ ] Add more logging everywhere
  - [ ] Tune discord's noisy logs
- Kubernetes
  - [ ] Create kubernetes directory with manifests
  - [ ] Pull those into or from internal k3s repo
