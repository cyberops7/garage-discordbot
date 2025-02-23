### Contributing Guidelines
**Code Quality**
* TBD

**Testing**
* TBD

### Dev Environment Setup

* Install `uv`
  * https://docs.astral.sh/uv/getting-started/installation/
* Install Python
  * ```shell
    uv python install $(cat .python-version)
    ```
* Install Python dependencies
  * ```shell
    uv sync --frozen
    ```
* Create your own `.env` file
  * ```shell
    cp sample.env .env
    ```
  * Put your bot token in the new .env file (this file is ignored by Git),
  or provide it to the shell environment, Docker container, etc. in some other way)
* Install development tools
  * Run `make deps` to check for non-python requiremed packaged
  * If you do not have `make` installed, you'll need to follow instructions for your OS
    * macOS
      * `brew install make`
    * Linux
      * via your package manager (e.g. `sudo apt install make`)
    * Windows
      * If you have WSL setup, install like you would in Linux
      * If you are using Cygwin, install it that way
      * If not, there appears to be a version more native for Windows: https://gnuwin32.sourceforge.net/packages/make.htm

### Adding dependencies
To add a runtime dependency:
```shell
uv add package-name
```
To add a development dependency:
```shell
uv add --dev package-name
```

### Updating dependencies
If you want to upgrade dependencies and test for compatibility, 
use `uv` to upgrade them all at once or one at a time.  
Do thorough compatibility testing before submitting a PR 
with updated dependencies.

* Upgrading a package
  * ```shell
    uv lock --upgrade-package package-name
    ```
* Upgrading all packages
  * ```shell
    uv lock --upgrade
    ```

### `make` targets


