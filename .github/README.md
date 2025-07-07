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

## Template Overview

### `aws-cloudformation-terraform-backend.yaml`
Deploys the complete Terraform backend infrastructure in a single CloudFormation stack.

**Parameters:**
- `StackName` (required): Name prefix for all resources
- `CreateStateBackend`: Whether to create state backend resources (default: true)
- `CreatePlanFileStorage`: Whether to create plan file storage resources (default: true)
- `CreateGitHubAccess`: Whether to create GitHub access resources (default: true)
- `GitHubOrg`: GitHub organization or username (default: cloudposse)
- `GitHubRepo`: GitHub repository name (default: "*")
- `BucketName`: S3 bucket name for state storage (default: tfstate)
- `DynamoDBTableName`: DynamoDB table name for state locking (default: tfstate)
- `KmsKeyAliasName`: KMS key alias (default: tfstate)
- `PlanBucketName`: S3 bucket name for plan files (default: tfplan)
- `PlanDynamoDBTableName`: DynamoDB table name for plan metadata (default: tfplan)
- `GitHubRoleName`: IAM role name (default: github-actions)
- `CreateOIDCProvider`: Whether to create OIDC provider (default: true)

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
 