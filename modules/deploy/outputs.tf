/** Helps to provide output logs for the varaible specified*/

output "bigquery_dataset" {
  description = "The BigQuery dataset to use"
  value       = var.source_dataset
}

output "bigquery_table" {
  description = "The BigQuery table to use"
  value       = local.bigquery_table_name
}
