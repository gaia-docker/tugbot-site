# Configuration
HUGO_VERSION ?= 0.16
HUGO_THEME ?= ""
GIT_COMMITTER_NAME ?= autohugo
GIT_COMMITTER_EMAIL ?= autohugo@autohugo.local

# System
OS = 64bit
ifeq ($(OS),Windows_NT)
	ARCH = windows
	FILEOS = Windows
	DOS = 64bit
	FOS = amd64
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		ARCH = linux
		FILEOS = linux
		DOS = amd64
		FOS = amd64
	endif
	ifeq ($(UNAME_S),Darwin)
		ARCH = MacOS
		FILEOS = darwin
		DOS = amd64
		FOS = amd64
	endif
endif

# Environment
SHELL := /bin/bash
BASE_PATH := $(shell pwd)
PUBLIC_PATH := $(BASE_PATH)/public
THEMES_PATH := $(BASE_PATH)/themes
THEME_NAME := $(shell basename $(HUGO_THEME))
THEME_PATH := $(THEMES_PATH)/$(THEME_NAME)
HUGO_PATH := $(BASE_PATH)/.hugo
HUGO_URL = github.com/spf13/hugo
HUGO_NAME := hugo_$(HUGO_VERSION)_$(ARCH)-$(OS)
HUGO_FNAME := hugo_$(HUGO_VERSION)_$(FILEOS)_$(FOS)
HUGO_DNAME := hugo_$(HUGO_VERSION)_$(FILEOS)_$(DOS)

# Tools
CURL = curl -L
HUGO = $(HUGO_PATH)/$(HUGO_DNAME)/$(HUGO_FNAME)
MKDIR = mkdir -p
GIT = git

# Rules
all: build

init:
	@if [ "$(HUGO_THEME)" == "" ]; then \
		echo "ERROR! Please set the env variable 'HUGO_THEME' (http://mcuadros.github.io/autohugo/documentation/working-with-autohugo/)"; \
		exit 1; \
	fi;

dependencies: init
	@if [[ ! -f $(HUGO) ]]; then \
		$(MKDIR) $(HUGO_PATH); \
		cd $(HUGO_PATH); \
		ext="zip"; \
		if [ "$(ARCH)" == "linux" ]; then ext="tar.gz"; fi; \
		file="hugo.$${ext}"; \
		$(CURL) https://$(HUGO_URL)/releases/download/v$(HUGO_VERSION)/$(HUGO_NAME).$${ext} -o $${file}; \
		if [ "$(ARCH)" == "linux" ]; then tar -xvzf $${file}; else unzip $${file}; fi; \
	fi;
	@if [[ ! -d $(THEME_PATH) ]]; then \
		$(MKDIR) $(THEMES_PATH); \
		cd $(THEMES_PATH); \
		$(GIT) clone $(HUGO_THEME) $(THEME_NAME); \
	fi;

build: dependencies
	$(HUGO) -t $(THEME_NAME)

server: build
	$(HUGO) --theme $(THEME_NAME) --buildDrafts --verbose

sed_to_github: init
	-grep -rl "https://www.tugbot.io" public | xargs sed -i.bak 's|https://www.tugbot.io|https://gaia-docker.github.io/tugbot-site|g'
	-find public -type f -name '*.bak' -delete

sed_to_s3: init
	-grep -rl "https://gaia-docker.github.io" public | xargs sed -i.bak 's|https://gaia-docker.github.io/tugbot-site|https://www.tugbot.io|g'
	-find public -type f -name '*.bak' -delete

publish: sed_to_github
	@if [ "$(CI)" == "" ]; then \
		echo "ERROR! Publish should be called only on CircleCI"; \
		exit 1; \
	fi;
	rm .gitignore
	$(GIT) config user.email "$(GIT_COMMITTER_EMAIL)"
	$(GIT) config user.name "$(GIT_COMMITTER_NAME)"
	$(GIT) add -A
	$(GIT) commit -m "updating site [ci skip]"
	$(GIT) push origin :gh-pages || true
	$(GIT) subtree push --prefix=public git@github.com:$(CIRCLE_PROJECT_USERNAME)/$(CIRCLE_PROJECT_REPONAME).git gh-pages

publish_to_s3: sed_to_s3
	@if [ "$(CI)" == "" ]; then \
		echo "ERROR! Publish should be called only on CircleCI"; \
		exit 1; \
	fi;
	aws s3 sync public s3://tugbot-site/ --delete

clean:
	rm -rf $(HUGO_PATH)
	rm -rf $(THEME_PATH)
