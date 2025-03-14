/**/
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
