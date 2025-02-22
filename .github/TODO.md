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
  - Clean up old Docker containers and buildx builders
  - Run as a prerequisite for `make run`, `make build`
- [x] `make publish`
  - Make it a variant `build`, just with an extra flag to push the image
- GitHub Actions
  - [ ] PRs
    - [ ] Lint/check code
    - [ ] Build image
    - [ ] Scan image
  - [ ] Accepted PRs
    - [ ] Build and publish image to ghcr
- Logging
  - [ ] Add more logging everywhere
  - [ ] Tune discord's noisy logs
- Kubernetes
  - [ ] Create kubernetes directory with manifests
  - [ ] Pull those into or from internal k3s repo
