DEV_IMAGE_TAG ?= development
PROD_IMAGE_TAG ?= production
AWS_ACCOUNT_ID ?= 123456789012
AWS_REGION ?= eu-central-1

build:
	docker build -t infrastructure/baas-client -f ./baas-client/Dockerfile ./baas-client

tag:
	docker tag infrastructure/baas-client:latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/infrastructure/baas-client:$(DEV_IMAGE_TAG)
	docker tag infrastructure/baas-client:latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/infrastructure/baas-client:$(PROD_IMAGE_TAG)

push:
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/infrastructure/baas-client:$(DEV_IMAGE_TAG)
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/infrastructure/baas-client:$(PROD_IMAGE_TAG)

create:
	aws ecr create-repository --repository-name infrastructure/baas-client

all: build tag push

DECODED_PASSWORD = $(shell aws ecr get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -D | cut -d: -f2)

auth:
	@docker login -u AWS -p $(DECODED_PASSWORD) $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com
