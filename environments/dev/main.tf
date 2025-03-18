
module "deploy-dev" {
  source                 = "../../modules/deploy"
  project_id             = "inlaid-goods-451523-i3"
  bigquery_table_name    = "local.bigquery_table_name"
  table_name             = "local.table_name"
  data_quality_spec_file = "local.data_quality_spec_file"
  environment            = "dev"
}
