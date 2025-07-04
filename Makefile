readme:
	atmos docs generate readme

lint:
	cfn-lint templates/*.yaml -I

deploy:
	aws cloudformation create-stack \
		--stack-name atmos-pro-backend \
		--template-body file://templates/atmos-pro.yaml \
		--capabilities CAPABILITY_NAMED_IAM \
		--parameters \
			ParameterKey=StackName,ParameterValue=atmos-pro-backend \
			ParameterKey=GitHubOrg,ParameterValue=cloudposse \
			ParameterKey=GitHubRepo,ParameterValue=demo \
			ParameterKey=CreateOIDCProvider,ParameterValue=false
