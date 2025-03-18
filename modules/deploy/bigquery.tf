/**
This Terraform code creates a Google BigQuery job for each table name in local.table_name. 
It constructs a unique job ID, executes a SQL query to select all rows from the specified table, and stores the results in a destination table. 
The lifecycle configuration ensures that changes to the job ID do not trigger a resource recreation.
*/

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
