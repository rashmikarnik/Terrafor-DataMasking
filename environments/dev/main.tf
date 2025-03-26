
module "deploy-dev" {
  source                 = "../../modules/deploy"
  project_id             = "inlaid-goods-451523-i3"
  bigquery_table_name    = "var.source_table"
  table_name             = "var.table_name"
  environment            = "dev"
}
