REGISTRY = docker.io
REPOSITORY = bluebeluga/golang

PUSH_REGISTRIES = $(REGISTRY)
PUSH_TAGS = $(TAG) go-$(TAG)

export FROM ?= bluebeluga/alpine:3.3
