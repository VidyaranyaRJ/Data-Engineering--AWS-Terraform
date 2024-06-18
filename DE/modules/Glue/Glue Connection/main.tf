########### AWS Glue Connection ############
resource "aws_glue_connection" "redshift_connection" {
  name = "redshift-serverless-connection"
  description = "Connection to Redshift Serverless"

  connection_properties = {
    "JDBC_CONNECTION_URL" : "jdbc:redshift://${var.conn_workgroup_name}.${var.account_id}.${var.region}.redshift-serverless.amazonaws.com:5439/dev",
    "USERNAME"            : var.username,
    "PASSWORD"            : var.password
  }

  tags = {
    Name = "GlueRedshiftServerlessConnection"
  }
}



