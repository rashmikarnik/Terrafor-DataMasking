/*
The module is named project-services.
The source attribute specifies the location of the external module, which is a Google Cloud Platform (GCP) project factory module.
The version attribute specifies the version of the module to use.
The disable_services_on_destroy attribute is set to false, which means that services will not be disabled when the Terraform configuration is destroyed.
The project_id and enable_apis attributes are set to the values of the corresponding input variables.
The activate_apis attribute is a list of APIs that should be activated in the GCP project.
*/
locals {
  env = var.environment
}

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "17.0.0"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "bigquery.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "config.googleapis.com",
    "dataplex.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
  ]
}

#random static id
resource "random_id" "id" {
keepers = {
    first = "${timestamp()}"
  }     
  byte_length = 8
}
