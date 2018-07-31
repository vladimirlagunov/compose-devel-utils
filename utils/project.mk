.DELETE_ON_ERROR:
.SECONDARY:

export SHELL := /bin/bash -e -o pipefail


default:
	$(error Specify explicitly target: `init` or `clean`.)

.PHONY: default


UTILS_ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)

PROJECT_FILES := \
		docker-compose.override.yml \
		my_devel_init \
		.env \
		$(UTILS_ROOT_DIR)/bin/docker-compose


init: $(PROJECT_FILES)
	./make-docker-compose-yml


clean:
	rm -f $(PROJECT_FILES)
	rmdir $(UTILS_ROOT_DIR)/bin || true


docker-compose.override.yml my_devel_init:
	cp $(UTILS_ROOT_DIR)/templates/$@ $@


$(UTILS_ROOT_DIR)/bin/docker-compose: $(UTILS_ROOT_DIR)/bin
	cd $(UTILS_ROOT_DIR) && utils/link-docker-compose $<


$(UTILS_ROOT_DIR)/bin:
	mkdir -p $(UTILS_ROOT_DIR)/bin


.env:
	$(UTILS_ROOT_DIR)/utils/make-env-file


.PHONY: $(UTILS_ROOT_DIR)/bin init clean .env
