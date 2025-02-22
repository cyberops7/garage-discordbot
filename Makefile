
.DEFAULT_GOAL := build
TAG := test

hello:
	echo "Hello world"

.PHONY: build
build: clean
	bash dev/build.sh --tag $(TAG)

.PHONY: clean
clean:
	bash dev/clean.sh

.PHONY: publish
publish: clean
	bash dev/build.sh --tag $(TAG) --push

.PHONY: run
run: clean
	bash dev/run.sh --tag $(TAG)

.PHONY: scan
scan:
	bash dev/scan.sh --tag $(TAG)
