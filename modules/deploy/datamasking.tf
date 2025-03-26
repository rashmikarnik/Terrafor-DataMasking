data "local_file" "table_schema" {
  filename = "schemas/masking-table-sample_schema.json"
}

locals {
  table_schema = jsondecode(data.local_file.table_schema.content)
  updated_schema = [for field in local.table_schema :
    merge(field,
      field.name == "status" ? { policyTags = { names = [google_data_catalog_policy_tag.policy_tag.name] } } : {}
    )
  ]
}

resource "google_bigquery_table" "my_table" {
  project    = var.project_id
  dataset_id = var.source_dataset
  table_id   = var.source_table
  schema     = jsonencode(local.updated_schema)
  depends_on = [ local.updated_schema ]
}

/* Terraform resource of type google_data_catalog_taxonomy, 
which represents a Data Catalog Taxonomy in Google Cloud
a taxonomy is a hierarchical grouping of policy tags that
can be used to classify data assets.*/
resource "google_data_catalog_taxonomy" "orders_taxonomy" {
  region                 = var.region
  display_name           = "taxonomy"
  description            = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

/*Terraform resource of type google_data_catalog_policy_tag, 
which represents a Policy Tag in Google Cloud Data Catalog.*/
resource "google_data_catalog_policy_tag" "policy_tag" {
  taxonomy     = google_data_catalog_taxonomy.orders_taxonomy.id
  display_name = "masking_policy_tag"
  description  = "A policy tag for masking"
}

resource "google_bigquery_routine" "custom_masking_routine" {
  dataset_id           = var.source_dataset
  routine_id           = "custom_masking_routine"
  routine_type         = "SCALAR_FUNCTION"
  language             = "SQL"
  data_governance_type = "DATA_MASKING"
  definition_body      = "SAFE_CAST(REGEXP_REPLACE(SAFE_CAST(status AS STRING), '[0-9]', 'X') AS STRING)"
  return_type = jsonencode({
    "typeKind" : "STRING"
  })

  arguments {
    name = "status"
    data_type = jsonencode({
      "typeKind" : "STRING"
    })
  }
}

resource "google_bigquery_datapolicy_data_policy" "data_policy" {
  location         = var.region
  data_policy_id   = "data_policy"
  policy_tag       = google_data_catalog_policy_tag.policy_tag.name
  data_policy_type = "DATA_MASKING_POLICY"

  data_masking_policy {
    routine = "projects/${var.project_id}/datasets/${var.source_dataset}/routines/custom_masking_routine"
  }
}
