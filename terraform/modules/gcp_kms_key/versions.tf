terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.75, < 5.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.75, < 5.0"
    }
  }
}
