## Dev Environment Setup

Ask AI: what instructions would I give collaborators for using the pyproject.toml and poetry.lock in the repo for setting up their own dev environment?

* Install `uv`
  * https://docs.astral.sh/uv/getting-started/installation/
* Install Python
  * `uv python install $(cat .python-version)`
* Install dependencies
  * `uv sync --frozen`


* Upgrading all packages
  * `uv lock --upgrade`
* Upgrading a package
  * `uv lock --upgrade-package package-name`