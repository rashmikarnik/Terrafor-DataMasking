/**
This Terraform code defines a resource for a Google Dataplex Data Quality (DQ) scan.
This line declares a resource of type google_dataplex_datascan with the name dq_scan.
The data block specifies the BigQuery table to be scanned. The resource argument constructs the table's resource path using the project ID, dataset ID, and table name.
The execution_spec block defines how the data scan is triggered. Here, it is set to run on demand.
The data_quality_spec block defines the data quality rules and specifications for the scan.
sampling_percent and row_filter are optional parameters that can be set from local variables.
The dynamic "rules" block iterates over the rules specific to each table. 
Each rule can have various expectations such as non_null_expectation, range_expectation, set_expectation, uniqueness_expectation, regex_expectation, statistic_range_expectation, row_condition_expectation, and table_condition_expectation.
project specifies the Google Cloud project ID, which is obtained from a module named project-services.
depends_on ensures that the data scan is created only after the google_bigquery_job.job resource is created.
*/




resource "google_dataplex_datascan" "dq_scan" {
  for_each = toset(var.source_table)
  location     = var.region
  data_scan_id = replace(lower(each.value), "_", "-")
  labels = {
    environment = local.env
  }


 //count = length(local.table_name)
  data {
    
    //resource = "//bigquery.googleapis.com/projects/${var.source_project}/datasets/${var.source_dataset}/tables/${local.table_name[count.index]}"
    resource = "//bigquery.googleapis.com/projects/${var.source_project}/datasets/${var.source_dataset}/tables/${each.key}"
  }

  execution_spec {
    trigger {
      on_demand {}
    }
  }

  # Custom logic to parse out rules metadata from a local rules.yaml file
  data_quality_spec {
    sampling_percent = try(local.sampling_percent[0], null)
    row_filter       = try(local.row_filter[0], null)

    dynamic "rules" {
      # Iterate over rules specific to the current table
    
      //for_each = try(local.rules[each.key],{})
      //for_each = local.rules_by_table[each.key] != null ? local.rules_by_table[each.key] : []
      for_each = try(local.rules[0][each.key], [])
      content {
        
        column      = try(rules.value.column, null)
        ignore_null = try(rules.value.ignore_null, null)
        dimension   = try(rules.value.dimension,"")
        description = try(rules.value.description, null)
        name        = try(rules.value.name, null)
        threshold   = try(rules.value.threshold, null)

        dynamic "non_null_expectation" {
          for_each = try(rules.value.non_null_expectation, null) != null ? [""] : []
          content {
          }
        }

        dynamic "range_expectation" {
          for_each = try(rules.value.range_expectation, null) != null ? [""] : []
          content {
            min_value          = try(rules.value.range_expectation.min_value, null)
            max_value          = try(rules.value.range_expectation.max_value, null)
            strict_min_enabled = try(rules.value.range_expectation.strict_min_enabled, null)
            strict_max_enabled = try(rules.value.range_expectation.strict_max_enabled, null)
          }
        }

        dynamic "set_expectation" {
          for_each = try(rules.value.set_expectation, null) != null ? [""] : []
          content {
            values = rules.value.set_expectation.values
          }
        }

        dynamic "uniqueness_expectation" {
          for_each = try(rules.value.uniqueness_expectation, null) != null ? [""] : []
          content {
          }
        }

        dynamic "regex_expectation" {
          for_each = try(rules.value.regex_expectation, null) != null ? [""] : []
          content {
            regex = rules.value.regex_expectation.regex
          }
        }

        dynamic "statistic_range_expectation" {
          for_each = try(rules.value.statistic_range_expectation, null) != null ? [""] : []
          content {
            min_value          = try(rules.value.statistic_range_expectation.min_value, null)
            max_value          = try(rules.value.statistic_range_expectation.max_value, null)
            strict_min_enabled = try(rules.value.statistic_range_expectation.strict_min_enabled, null)
            strict_max_enabled = try(rules.value.statistic_range_expectation.strict_max_enabled, null)
            statistic          = rules.value.statistic_range_expectation.statistic
          }
        }

        dynamic "row_condition_expectation" {
          //for_each = try(rules.value.row_condition_expectation, null) != null && local.data_quality_spec_file == local.data_quality_spec_file [local.table_name[count.index]] ? [""] : []
          //for_each = try(rules.value.row_condition_expectation != null) ? [""] : []
          //for_each = try([rules.value.row_condition_expectation], []) != [] ? [""] : []
           for_each = try(rules.value.row_condition_expectation, null) != null ? [""] : []
          content {
            sql_expression = rules.value.row_condition_expectation.sql_expression
          }
        } 

        dynamic "table_condition_expectation" {
          for_each = try(rules.value.table_condition_expectation, null) != null ? [""] : []
          content {
            sql_expression = rules.value.table_condition_expectation.sql_expression
          }
        }

      }
    }
  }

  project = module.project-services.project_id

  depends_on = [google_bigquery_job.job]

lifecycle {
    create_before_destroy = false
  }
}

output "rules" {
  value = local.rules
}
