data "aws_redshiftserverless_namespace" "example" {
  namespace_name = "rs-ns-inc-load"
}

data "aws_redshiftserverless_workgroup" "example" {
  workgroup_name = "rs-wg-inc-load"
}

data "aws_redshiftserverless_credentials" "example" {
  workgroup_name = "rs-wg-inc-load"
}

data "aws_caller_identity" "current" {}


module "glue_connection" {
  source                                 = "../../../modules/Glue/Glue Connection"
  region = var.region
  account_id = data.aws_caller_identity.current.account_id
  conn_workgroup_name = data.aws_redshiftserverless_workgroup.example.workgroup_name


  username = data.aws_redshiftserverless_credentials.example.db_user
  password = data.aws_redshiftserverless_credentials.example.db_password
}

