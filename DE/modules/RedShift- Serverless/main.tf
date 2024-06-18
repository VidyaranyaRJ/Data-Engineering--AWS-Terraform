############### Redshift ################

resource "aws_redshiftserverless_namespace" "example" {
  namespace_name = var.namespace_name

  admin_user_password = var.admin_user_password
  admin_username = var.admin_username
}


resource "aws_redshiftserverless_workgroup" "example" {
  namespace_name = aws_redshiftserverless_namespace.example.namespace_name
  workgroup_name = var.workgroup_name
  publicly_accessible = var.true_false
  depends_on = [
    aws_redshiftserverless_namespace.example, aws_vpc_endpoint.s3
  ]
}


################### VPC Endpoint #################
data "aws_vpc" "default" {
  default = true
}

resource "aws_route_table" "example" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.default.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.example.id,
  ]
  depends_on = [ aws_route_table.example ]
}


