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
  }
}

provider "google" {

}
