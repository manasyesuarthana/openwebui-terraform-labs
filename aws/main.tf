terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }

    terracurl = {
      source = "devops-rob/terracurl"
      version = "2.0.0"
    }
  }
}

provider "aws" {}