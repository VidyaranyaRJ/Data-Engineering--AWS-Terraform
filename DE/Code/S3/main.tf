module "s3" {
  source                                 = "../../modules/S3"
  bucket_name = var.bucket_name
  key         = var.key
  path        = var.path
  true_false = var.true_false
}
