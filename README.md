# Site2Site-Azure-Vnet

This repository manages the infrastructure for creating and managing an **Azure Virtual Network (VNet)** for hosting an Azure VM instance. The VNet is dynamically named based on the environment (development, production, or testing) and is deployed using **Terraform**. The repository also implements a full **CI/CD pipeline** for validating and deploying infrastructure changes.

## Repository Structure

```plaintext
Site2Site-Azure-Vnet/
│
├── .github/
│   └── workflows/
│       └── azure-terraform-pipeline.yml      # GitHub Actions CI/CD pipeline script
│
├── main.tf                                   # Terraform configuration for Azure VNet
├── variables.tf                              # Variables for Terraform configuration
├── outputs.tf                                # Outputs for Terraform (e.g., VNet name, subnet details)
├── providers.tf                              # Provider configuration for Azure
├── README.md                                 # Project overview and documentation (this file)
```

## Repository Map

- **.github/workflows/azure-terraform-pipeline.yml**: 
  This directory contains the **CI/CD pipeline** script, responsible for validating, testing, and deploying infrastructure based on branch pushes and pull requests.

- **main.tf**: 
  The main **Terraform configuration** file for creating the Azure VNet and its associated resources (e.g., subnets).

- **variables.tf**: 
  Contains the variables used in the Terraform configuration, such as the environment, VNet CIDR block, and subnet CIDR block.

- **outputs.tf**: 
  Specifies the outputs of the Terraform configuration, such as the VNet name and subnet details.

- **providers.tf**: 
  Defines the provider configuration, specifically for Azure, to connect Terraform with your Azure account.

## Branches

The repository uses three branches to manage different stages of the development and deployment lifecycle:

- **testing**:
  - This branch is used for making and testing changes to the infrastructure configuration before merging to development or production.
  - Any infrastructure changes pushed to this branch will trigger the pipeline for validation and testing but will not be applied.

- **development**:
  - Changes that pass testing are merged into this branch.
  - The pipeline will deploy the infrastructure in a **development environment**, using resources named accordingly (e.g., `VNet_development`).

- **production**:
  - The final branch where fully tested and approved changes are merged.
  - The pipeline will deploy the infrastructure in the **production environment** (e.g., `VNet_production`).

## CI/CD Pipeline

The **CI/CD pipeline** is managed by **GitHub Actions** and is triggered on:

- **Pull requests**: For testing and validating infrastructure changes.
- **Pushes**: For deploying the infrastructure when changes are pushed to the `development` or `production` branches.

### Pipeline Workflow

- **Validate and Test**:
  - The pipeline starts by validating the **Terraform configuration** using `terraform validate`.
  - It then runs **Terraform Plan** to ensure the changes are correct and to generate a plan for deployment.
  - **Security Checks with TFSec**: A `tfsec` scan is performed to ensure the Terraform configuration follows security best practices.

- **Manual Approval**:
  - After validation, the pipeline pauses for **manual approval**. This step ensures that infrastructure changes are reviewed before they are deployed.

- **Deploy Terraform Configuration**:
  - Once approved, the pipeline deploys the infrastructure using `terraform apply`, passing the appropriate environment variables (e.g., `Environment=development`).

- **Clean-up**:
  - To prevent unnecessary costs, the pipeline waits for 1 hour and then automatically destroys the Terraform resources using `terraform destroy`.

## Terraform Configuration (`main.tf`)

The **Terraform configuration** is responsible for creating the **Azure VNet** and its associated resources (subnet). It dynamically names resources based on the environment (development, production, or testing).

### Configuration Overview

- **Variables**:
  - The configuration accepts variables for `Environment` (e.g., `development`, `production`), the **VNet CIDR block**, and the **Subnet CIDR block**. This allows the flexibility to use different environments and IP ranges.

- **Resources**:
  - **VNet**: The VNet is created with a CIDR block of `10.0.0.0/16` and is dynamically named based on the environment.
  - **Subnet**: A subnet with CIDR block `10.0.1.0/24` is created inside the VNet to host an Azure VM.

- **Outputs**:
  - The configuration outputs the **VNet name** and **Subnet details** for easy reference after the deployment.

## How the Workflow and Terraform Configuration Work Together

- When a developer pushes to one of the branches, the **CI/CD pipeline** triggers and first validates the Terraform configuration.
- The infrastructure is deployed in either the development or production environment based on the branch name.
- Resources (VNet, subnet) are dynamically named based on the environment, ensuring isolation and easy identification of resources in different stages.
