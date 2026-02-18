terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.19.0"
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

provider "google" {

}

variable "open_webui_user" {
  description = "Username to access openwebui"
  default     = "admin@demo.gs"
}

