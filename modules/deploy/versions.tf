/*
The code uses a Terraform module from the "terraform-google-modules" repository, specifically the "project-factory" module, version 17.0.0.
The disable_services_on_destroy variable is set to false, which means that when the Terraform configuration is destroyed, the enabled APIs will not be disabled.
*/


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.83.0, < 6.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.83.0, < 6.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.2.1"
    }
  }
  required_version = ">= 0.13"

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-analytics-lakehouse/v0.3.0"
  }
}

provider "google" {
  project = "inlaid-goods-451523-i3"
  region  = "us-central1"
}
