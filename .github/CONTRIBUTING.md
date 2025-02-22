### Contributing Guidelines
**Code Quality**
* TBD

**Testing**
* TBD

### Dev Environment Setup

* Install `uv`
  * https://docs.astral.sh/uv/getting-started/installation/
* Install Python
  * `uv python install $(cat .python-version)`
* Install dependencies
  * `uv sync --frozen`


* Create your own `.env` file
  * `cp sample.env .env`
  * Put your bot token in the new .env file (this file is ignored by Git)
  (or provide it to the shell environment, Docker container, etc. in some other way)

### Updating dependencies
If you want to upgrade dependencies and test for compatibility, 
use `uv` to upgrade them all or one at a time.  
Do thorough compatibility testing before submitting a PR 
with updated dependencies.

* Upgrading all packages
  * `uv lock --upgrade`
* Upgrading a package
  * `uv lock --upgrade-package package-name`


