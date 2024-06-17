module "glue" {
  source                                 = "../../modules/Glue"
  database_name  = var.database_name
  iam_role_name   = var.iam_role_name
  glue_crawler_name = var.glue_crawler_name
  s3_bucket_name = var.s3_bucket_name 
  cron  =  var.cron
}

