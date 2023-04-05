.PHONY: help
help: bootstrap
	@cat README.md

.PHONY: bootstrap
bootstrap:
	bash ./bootstrap.sh
