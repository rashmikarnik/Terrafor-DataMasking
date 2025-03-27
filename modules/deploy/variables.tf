
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
  default     = "rashmi_d5d60989"
}

variable "source_table" {
  type        = string
  description = "Source table for the data"
  default     = "masking-table-sample"
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


