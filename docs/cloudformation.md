# CloudFormation Parameters

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
