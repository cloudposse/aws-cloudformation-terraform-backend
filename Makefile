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
	aws cloudformation deploy \
	  --stack-name atmos-pro-ex1 \
	  --template-body file://templates/aws-cloudformation-terraform-backend.yaml \
	  --capabilities CAPABILITY_NAMED_IAM \
	  --no-fail-on-empty-changeset \
	  --parameters \
	  	ParameterKey=GitHubOrg,ParameterValue=cloudposse-examples \
	  	ParameterKey=CreateOIDCProvider,ParameterValue=false;

# This deletes Cloud Posse's internal test stack
# See https://github.com/cloudposse-examples/infra-demo-atmos-pro
delete:
	aws cloudformation delete-stack --stack-name atmos-pro-ex1