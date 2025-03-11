# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

variable "schema_file" {
  type        = string
  description = "Schema file for table"
  default     = "schemas/orders_schema.json"
}

variable "bigquery_table_name" {
  type        = string
  description = "Name ot the BQ table"
  
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

locals {
  bigquery_table_name = [for table in var.source_table : trim("${var.source_project}.${var.source_dataset}.${table}",".")]
  //data_quality_spec_file = [for dqFileName in var.source_dq_file :"${dqFileName}"]
  data_quality_spec_file = var.source_dq_file
}
