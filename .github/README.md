# aws-cloudformation-terraform-backend


CloudFormation template that sets up a complete Terraform backend infrastructure on AWS with three distinct resource types: state backend resources (S3 bucket, KMS key, DynamoDB table for Terraform/OpenTofu state), plan file storage resources (S3 bucket, DynamoDB table for Cloud Posse GitHub Actions), and GitHub Actions access resources (OIDC provider, IAM roles for secure authentication).


## Introduction

This repository contains a CloudFormation template that sets up a complete Terraform backend infrastructure on AWS. It creates three distinct types of resources:

### 1. State Backend Resources
Used for Terraform or OpenTofu state storage:
- S3 bucket for Terraform state storage
- KMS key for encryption
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

[![Launch Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=terraform-backend&templateURL=https://s3.amazonaws.com/cloudposse-terraform-backend-quickstart/aws-cloudformation-terraform-backend.yaml)

### Or deploy via AWS CLI

#### Option 1: Deploy from Remote Template

```bash
aws cloudformation create-stack \
  --stack-name my-backend \
  --template-url https://s3.amazonaws.com/cloudposse-terraform-backend-quickstart/aws-cloudformation-terraform-backend.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=StackName,ParameterValue=my-backend \
    ParameterKey=GitHubOrg,ParameterValue=your-org \
    ParameterKey=GitHubRepo,ParameterValue=your-repo
```

#### Option 2: Deploy from Local Template

```bash
aws cloudformation create-stack \
  --stack-name my-backend \
  --template-body file://templates/aws-cloudformation-terraform-backend.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=StackName,ParameterValue=my-backend \
    ParameterKey=GitHubOrg,ParameterValue=your-org \
    ParameterKey=GitHubRepo,ParameterValue=your-repo
```

## Local Development

### Prerequisites
- AWS CLI configured with appropriate permissions
- Python and pip for cfn-lint (optional but recommended)

### Install Dependencies

To install the dependencies, run:

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

## CloudFormation Parameters

| Parameter | Required | Description | Default |
|-----------|----------|-------------|---------|
| `StackName` | - | (Required) Name of the stack (used as prefix for all resources). This must be globally unique | - |
| `CreateStateBackend` | - | Set to 'true' to create state backend resources (S3 bucket, DynamoDB table, KMS key), 'false' to skip | true |
| `BucketName` | - | Name of the S3 bucket for Terraform state | tfstate |
| `DynamoDBTableName` | - | Name of the DynamoDB table for state locking | tfstate |
| `KmsKeyAliasName` | - | Alias for the KMS key used for encryption | tfstate |
| `CreatePlanFileStorage` | - | Set to 'true' to create plan file storage resources (S3 bucket, DynamoDB table), 'false' to skip | true |
| `PlanBucketName` | - | Name of the S3 bucket for Terraform plan files | tfplan |
| `PlanDynamoDBTableName` | - | Name of the DynamoDB table for Terraform plan metadata | tfplan |
| `CreateGitHubAccess` | - | Set to 'true' to create GitHub access resources (OIDC provider, IAM role), 'false' to skip | true |
| `CreateOIDCProvider` | - | Set to 'true' to create the GitHub OIDC provider, 'false' to skip (if it already exists) | true |
| `GitHubOrg` | - | GitHub organization or username | cloudposse |
| `GitHubRepo` | - | GitHub repository name | * |
| `GitHubRoleName` | - | Name of the IAM role for GitHub Actions | github-actions |










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
 