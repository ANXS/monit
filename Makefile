.PHONY: lint test test-all test-debian12 test-debian13 test-ubuntu2004 \
	test-ubuntu2204 test-ubuntu2404 test-reset clean distclean

VENV := .venv
BIN := $(VENV)/bin
export PATH := $(CURDIR)/$(BIN):$(PATH)

$(VENV): requirements-dev.txt
	python3 -m venv $(VENV)
	$(BIN)/pip install --upgrade pip
	$(BIN)/pip install -r requirements-dev.txt
	@touch $(VENV)

lint: $(VENV)
	$(BIN)/yamllint -c .yamllint defaults handlers meta molecule tasks .github
	$(BIN)/ansible-lint -c .ansible-lint defaults handlers meta molecule tasks

test: lint test-all

test-debian12: $(VENV)
	MOLECULE_OS=debian MOLECULE_VERSION=12 \
		MOLECULE_IMAGE=geerlingguy/docker-debian12-ansible:latest \
		$(BIN)/molecule test

test-debian13: $(VENV)
	MOLECULE_OS=debian MOLECULE_VERSION=13 \
		MOLECULE_IMAGE=geerlingguy/docker-debian13-ansible:latest \
		$(BIN)/molecule test

test-ubuntu2004: $(VENV)
	MOLECULE_OS=ubuntu MOLECULE_VERSION=2004 \
		MOLECULE_IMAGE=geerlingguy/docker-ubuntu2004-ansible:latest \
		$(BIN)/molecule test

test-ubuntu2204: $(VENV)
	MOLECULE_OS=ubuntu MOLECULE_VERSION=2204 \
		MOLECULE_IMAGE=geerlingguy/docker-ubuntu2204-ansible:latest \
		$(BIN)/molecule test

test-ubuntu2404: $(VENV)
	MOLECULE_OS=ubuntu MOLECULE_VERSION=2404 \
		MOLECULE_IMAGE=geerlingguy/docker-ubuntu2404-ansible:latest \
		$(BIN)/molecule test

test-all: test-debian12 test-debian13 test-ubuntu2004 test-ubuntu2204 test-ubuntu2404

test-reset: $(VENV)
	$(BIN)/molecule reset

clean:
	$(BIN)/molecule destroy 2>/dev/null || true

distclean: clean
	rm -rf $(VENV)
