.PHONY: docs readme
# Variables
DOCS_PATH = docs/cloudformation.md

readme: docs
	atmos docs generate readme

docs:
	@echo "Generating CloudFormation parameter documentation..."
	@echo "# CloudFormation Parameters" > $(DOCS_PATH)
	@echo "" >> $(DOCS_PATH)
	@echo "| Parameter | Required | Description | Default |" >> $(DOCS_PATH)
	@echo "|-----------|----------|-------------|---------|" >> $(DOCS_PATH)
	@yq eval '.Parameters | to_entries | .[] | "| `" + .key + "` | - | " + (.value.Description // "") + " | " + (.value.Default // "-") + " |"' templates/aws-cloudformation-terraform-backend.yaml >> $(DOCS_PATH)
	@echo "Parameter documentation generated in $(DOCS_PATH)"

lint:
	cfn-lint templates/*.yaml -I

deploy:
	aws cloudformation create-stack \
		--stack-name atmos-pro-backend \
		--template-body file://templates/aws-cloudformation-terraform-backend.yaml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters \
			ParameterKey=StackName,ParameterValue=atmos-pro-backend \
			ParameterKey=GitHubOrg,ParameterValue=cloudposse \
			ParameterKey=GitHubRepo,ParameterValue=demo \			ParameterKey=CreateOIDCProvider,ParameterValue=false
