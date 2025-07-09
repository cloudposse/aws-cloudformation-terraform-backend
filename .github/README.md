# aws-cloudformation-terraform-backend


CloudFormation template that sets up a complete Terraform backend infrastructure on AWS with three distinct resource types: state backend resources (S3 bucket, DynamoDB table for Terraform/OpenTofu state with AWS managed KMS encryption), plan file storage resources (S3 bucket, DynamoDB table for Cloud Posse GitHub Actions), and GitHub Actions access resources (OIDC provider, IAM roles for secure authentication).


## Introduction

This repository contains a CloudFormation template that sets up a complete Terraform backend infrastructure on AWS. It creates three distinct types of resources:

### 1. State Backend Resources
Used for Terraform or OpenTofu state storage:
- S3 bucket for Terraform state storage
- DynamoDB table for state locking

### 2. Plan File Storage Resources
Used with Cloud Posse GitHub Actions to store plan files between planning and applying:
- S3 bucket for Terraform plan files
- DynamoDB table for plan metadata

### 3. GitHub Actions Access Resources
Used for secure GitHub Actions integration:
- IAM roles and policies for GitHub OIDC integration
- GitHub OIDC provider for secure authentication

The template deploys all resources in a single CloudFormation stack for easy management and deployment, with options to create only the resources you need.



## Usage

## Quick Start

Deploy the complete Terraform backend infrastructure in a single CloudFormation stack:

> [!IMPORTANT]
> Your stack name must be unique across all AWS accounts. We use the stack name as part of the S3 bucket and DynamoDB table IDs.

[<img width="144" height="27" src="../docs/launch_stack.png" alt="Launch Stack" />](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=my-terraform-backend&templateURL=https://s3.amazonaws.com/cplive-core-ue2-public-cloudformation/aws-cloudformation-terraform-backend.yaml)

### Or deploy via AWS CLI

#### Option 1: Download from S3 and Deploy

Download the template and deploy it locally:

```bash
# Download the template
curl -o /tmp/terraform-backend.yaml https://s3.amazonaws.com/cplive-core-ue2-public-cloudformation/aws-cloudformation-terraform-backend.yaml

# Deploy the template
aws cloudformation deploy \
  --stack-name my-backend \
  --template-file /tmp/terraform-backend.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --parameter-overrides GitHubOrg=your-org
```

#### Option 2: Clone Repo and Deploy

Clone the repository and deploy the template from the local directory:

```bash
# Clone the repository
git clone git@github.com:cloudposse/aws-cloudformation-terraform-backend.git
cd aws-cloudformation-terraform-backend

# Deploy the template
aws cloudformation deploy \
  --stack-name my-backend \
  --template-file templates/aws-cloudformation-terraform-backend.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --parameter-overrides GitHubOrg=your-org
```

## Usage with Atmos

Once deployed, you will need to add the new role and plan file storage configuration to your Atmos configuration.

```yaml
integrations:
  github:
    gitops:
      terraform-version: "1.5.7"
      artifact-storage:
        region: "us-east-1" # Ensure this matches the region where the template was deployed
        bucket: "my-backend-tfplan" # Get this value from the PlanBucketName output
        table: "my-backend-tfplan" # Get this value from the PlanDynamoDBTableName output
        role: "arn:aws:iam::123456789012:role/my-backend-github-actions" # Get this value from the GitHubActionsRoleARN output
      role:
        plan: "arn:aws:iam::123456789012:role/my-backend-github-actions" # Get this value from the GitHubActionsRoleARN output
        apply: "arn:aws:iam::123456789012:role/my-backend-github-actions" # Get this value from the GitHubActionsRoleARN output
```

Then use the state backend with Atmos by specifying the S3 bucket and DynamoDB table.

```yaml
terraform:
  backend_type: s3
  backend:
    s3:
      bucket: my-backend-tfstate # Get this value from the StateBucketName output
      dynamodb_table: my-backend-tfstate # Get this value from the StateDynamoDBTableName output
      role_arn: "" # Leave empty to use the current AWS credentials
      encrypt: true
      key: terraform.tfstate
      acl: bucket-owner-full-control
      region: us-east-1 # Ensure this matches the region where the template was deployed
  remote_state_backend:
    s3:
      role_arn: "" # Leave empty to use the current AWS credentials
```

## Destroying the Template

To destroy the template, run:

```bash
aws cloudformation delete-stack --stack-name my-backend
```

This will destroy the stack and all the resources it created. However, if the S3 bucket is not empty, the stack will fail to destroy.

To destroy the stack and empty the S3 bucket, run:

```bash
aws cloudformation delete-stack --stack-name my-backend --deletion-mode FORCE_DELETE_STACK
```

> [!WARNING]
> This will destroy the state files and empty the S3 bucket. This is a destructive action and cannot be undone.

## CloudFormation Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `CreateStateBackend` | Set to 'true' to create state backend resources (S3 bucket, DynamoDB table), 'false' to skip | true |
| `CreatePlanFileStorage` | Set to 'true' to create plan file storage resources (S3 bucket, DynamoDB table), 'false' to skip | true |
| `CreateGitHubAccess` | Set to 'true' to create GitHub access resources (OIDC provider, IAM role), 'false' to skip | true |
| `CreateOIDCProvider` | Set to 'true' to create the GitHub OIDC provider, 'false' to skip (if it already exists) | true |
| `GitHubOrg` | GitHub organization or username (case sensitive) |  |
| `GitHubRepo` | GitHub repository name. Set to `*` to allow all repositories | * |

## Local Development

### Prerequisites
- AWS CLI configured with appropriate permissions
- Python and pip for cfn-lint (optional but recommended)

### Install Dependencies

For local CloudFormation development, install the dependencies with pip. We recommend using cfn-lint to validate the template locally. This is not required to deploy the template itself.

```bash
pip install -r requirements.txt
```

### Validate Template Locally

To validate the template locally, run:

```bash
make lint
```

### Building Documentation

To build the documentation for this repository, run:

```bash
atmos docs generate readme
```

This command generates the README.md file from the README.yaml configuration.

## Repository Structure

```
.
├── .github/
│   ├── README.md             # Generated README
│   ├── README.md.gotmpl      # README template
│   └── workflows/            # GitHub Actions workflows
│       ├── validate-template.yml # Validates the template
│       └── publish-template.yml # Publishes the template
├── templates/                # CloudFormation template
│   └── aws-cloudformation-terraform-backend.yaml
├── atmos.yaml                # Atmos configuration
├── Makefile                  # Build and deployment commands
├── requirements.txt          # Python dependencies
└── README.yaml              # This file
```










## License

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License"></a>

<details>
<summary>Preamble to the Apache License, Version 2.0</summary>
<br/>
<br/>



```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
</details>


---
Copyright © 2017-2025 [Cloud Posse, LLC](https://cpco.io/copyright)
 