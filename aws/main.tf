terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.30.0"
    }

    terracurl = {
      source  = "devops-rob/terracurl"
      version = "2.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {}

variable "open_webui_user" {
  description = "Username to access the web UI"
  default     = "admin@demo.gs"
}
