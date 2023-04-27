terraform {
  # required providers Terraform will use to provision your infrastructure.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # optional -  avoid install a version of the provider that does not work with your configuration.
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# plugin that Terraform uses to create and manage your resources.
provider "aws" {
  region  = "us-east-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context_cluster   = "basic-cluster.us-east-1.eksctl.io"
}

provider "helm" {
  kubernetes {
    # host                   = var.cluster_endpoint
    config_path = "~/.kube/config"
  }
}