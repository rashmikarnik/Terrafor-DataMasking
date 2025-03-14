
variable "project_id" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "region" {
  type        = string
  description = "Google Cloud Region"
  default     = "us-central1"
}

variable "labels" {
  type        = map(string)
  description = "A map of labels to apply to contained resources."
  default     = { "auto-data-quality" = true }
}

variable "enable_apis" {
  type        = string
  description = "Whether or not to enable underlying apis in this solution. ."
  default     = true
}

variable "force_destroy" {
  type        = string
  description = "Whether or not to protect GCS resources from deletion when solution is modified or changed."
  default     = false
}

variable "deletion_protection" {
  type        = string
  description = "Whether or not to protect GCS resources from deletion when solution is modified or changed."
  default     = false
}

variable "environment" {
  type        = string
  description = "Lifecycle environment"
  default     = "dev"
}

variable "source_project" {
  type        = string
  description = "Source project for the data"
  default     = "inlaid-goods-451523-i3"
}

variable "source_dataset" {
  type        = string
  description = "Source dataset for the data"
  default     = "githubAction_example"
}

variable "source_table" {
  type        = list(string)
  description = "Source table for the data"
  default     = ["EPM_PINS_UDOT","dev"]
}

# variable "schema_file" {
#   type        = string
#   description = "Schema file for table"
#   default     = "schemas/orders_schema.json"
# }

variable "bigquery_table_name" {
  type        = string
  description = "Name ot the BQ table"
  
}

variable "table_name"{
   type        = string
   description = "only table name"
}

variable "source_dq_file" {
  type        = list(string)
  description = "data quality files"
  default     = ["/rules/epmpins.yaml","/rules/orders.yaml"]
}

variable "data_quality_spec_file" {
  type        = string
  description = "data quality files"
 
}
# variable "rashmi" {
#   type        = string
#   description = "data quality files"
# }
variable "table_to_dq_file" {
  type = map(string)
  default = {
    "EPM_PINS_UDOT" = "/rules/epmpins.yaml",
    "dev"             = "/rules/orders.yaml",
  }
}


locals {
  bigquery_table_name = [for table in var.source_table : "${var.source_project}.${var.source_dataset}.${table}"]
  table_name = [for tableName in var.source_table:"${tableName}"]
  //table_to_dq_file     = zipmap(var.source_table, var.source_dq_file)
 // data_quality_spec_file = local.table_to_dq_file[var.table_name]
 // rashmi = values(local.table_to_dq_file)
  //data_quality_spec_file = var.source_dq_file
  data_quality_spec_file = { for table_name in var.source_table : table_name => var.table_to_dq_file[table_name] }
}

output "tttttt"{
  value = local.data_quality_spec_file
}