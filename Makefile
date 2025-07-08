.PHONY: readme

readme:
	atmos docs generate readme

lint:
	cfn-lint templates/aws-cloudformation-terraform-backend.yaml

validate:
	aws cloudformation validate-template --template-body file://templates/aws-cloudformation-terraform-backend.yaml

# This deploys the cloudformation template to Cloud Posse's test organization.
# See https://github.com/cloudposse-examples/infra-demo-atmos-pro
deploy:
	@echo "Checking if stack exists..."
	@if aws cloudformation describe-stacks --stack-name atmos-pro-example-advanced >/dev/null 2>&1; then \
		echo "Stack exists, updating..."; \
		aws cloudformation update-stack \
			--stack-name atmos-pro-example-advanced \
			--template-body file://templates/aws-cloudformation-terraform-backend.yaml \
			--capabilities CAPABILITY_NAMED_IAM \
			--parameters \
				ParameterKey=StackName,ParameterValue=atmos-pro-ex1 \
				ParameterKey=GitHubOrg,ParameterValue=cloudposse-examples \
				ParameterKey=CreateOIDCProvider,ParameterValue=false; \
	else \
		echo "Stack does not exist, creating..."; \
		aws cloudformation create-stack \
			--stack-name atmos-pro-example-advanced \
			--template-body file://templates/aws-cloudformation-terraform-backend.yaml \
			--capabilities CAPABILITY_NAMED_IAM \
			--parameters \
				ParameterKey=StackName,ParameterValue=atmos-pro-ex1 \
				ParameterKey=GitHubOrg,ParameterValue=cloudposse-examples \
				ParameterKey=CreateOIDCProvider,ParameterValue=false; \
	fi

delete:
	aws cloudformation delete-stack --stack-name atmos-pro-example-advanced