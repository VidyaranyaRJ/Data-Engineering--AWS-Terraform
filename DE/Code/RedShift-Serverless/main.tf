module "redshift" {
  source                                 = "../../modules/RedShift- Serverless"
  namespace_name = var.namespace_name
  workgroup_name = var.workgroup_name
  admin_user_password = var.admin_user_password
  admin_username = var.admin_username  
  true_false = var.true_false
}



