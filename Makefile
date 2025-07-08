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
	aws cloudformation deploy \
	  --stack-name atmos-pro-ex1 \
	  --template-body file://templates/aws-cloudformation-terraform-backend.yaml \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --parameters \
	      ParameterKey=GitHubOrg,ParameterValue=cloudposse-examples \
	      ParameterKey=CreateOIDCProvider,ParameterValue=false;

delete:
	aws cloudformation delete-stack --stack-name atmos-pro-ex1