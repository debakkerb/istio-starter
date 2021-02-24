provider "google" {
  region = var.default_region
}

provider "google-beta" {
  region = var.default_region
}

terraform {
  required_version = "~> 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.58.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.58.0"
    }
  }
}