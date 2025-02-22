
.DEFAULT_GOAL := build
TAG := test

hello:
	echo "Hello world"

.PHONY: build
build:
	bash dev/build.sh $(TAG)

.PHONY: publish
publish: build
#publish:
	bash dev/publish.sh $(TAG)

.PHONY: run
run:
	bash dev/run.sh $(TAG)

.PHONY: scan
scan:
	bash dev/scan.sh $(TAG)
