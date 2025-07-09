.PHONY: readme lint validate deploy delete init-stack-name

STACK_NAME_FILE := .stack-name

# Generate a unique stack name and save it
init-stack-name:
	@echo "Generating stack name..."
	@echo "atmos-pro-$(shell date +%Y%m%d%H%M%S)" > $(STACK_NAME_FILE)
	@echo "Saved stack name: $$(cat $(STACK_NAME_FILE))"

# Read the stack name from the file
STACK_NAME := $(shell cat $(STACK_NAME_FILE) 2>/dev/null)

readme:
	atmos docs generate readme

lint:
	cfn-lint templates/aws-cloudformation-terraform-backend.yaml

validate:
	aws cloudformation validate-template --template-body file://templates/aws-cloudformation-terraform-backend.yaml

# This deploys the cloudformation template to Cloud Posse's test organization.
# See https://github.com/cloudposse-examples/infra-demo-atmos-pro
deploy: $(STACK_NAME_FILE)
	aws cloudformation deploy \
	  --stack-name $(STACK_NAME) \
	  --template-file templates/aws-cloudformation-terraform-backend.yaml \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --no-fail-on-empty-changeset \
	  --parameter-overrides GitHubOrg=cloudposse-examples CreateOIDCProvider=false

# This deletes Cloud Posse's internal test stack
# See https://github.com/cloudposse-examples/infra-demo-atmos-pro
delete:
	aws cloudformation delete-stack --stack-name $(STACK_NAME_FILE)