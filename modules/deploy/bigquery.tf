/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Set up BigQuery resources
# # Create the BigQuery dataset
# resource "google_bigquery_dataset" "dataset" {
#   project                    = module.project-services.project_id
#   dataset_id                 = "rashmi_${random_id.id.hex}"
#   friendly_name              = "rashmi table"
#   description                = "rashmi table"
#   location                   = var.region
#   labels                     = var.labels
#   delete_contents_on_destroy = var.force_destroy
# }

# resource "google_bigquery_table" "table" {
#   project             = module.project-services.project_id
#   deletion_protection = var.deletion_protection
#   dataset_id          = google_bigquery_dataset.dataset.dataset_id
#   table_id            = local.env

#   schema = file("${path.module}/${var.schema_file}")
# }

resource "google_bigquery_job" "job" {
  //for_each = toset(local.bigquery_table_name)
 count = length(local.table_name)
  project = module.project-services.project_id
  job_id  = "${local.table_name[count.index]}_${random_id.id.hex}"

  labels = {
    "env" = local.env
  }
  query {
    query = "SELECT * FROM `${var.source_project}.${var.source_dataset}.${local.table_name[count.index]}`"
    //query = "SELECT * FROM `${var.source_project}.${var.source_dataset}.${local.bigquery_table_name[count.index]}`"

    destination_table {
      project_id = var.source_project
      dataset_id = var.source_dataset
      table_id   = local.table_name[count.index]
    }
  }
  lifecycle {
    ignore_changes = [job_id]
  }
}
