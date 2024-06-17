############### Necessary IAM roles for Glue ################

resource "aws_iam_role" "example" {
  name = var.iam_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
)

}
resource "aws_iam_role_policy" "s3_access" {
  role = aws_iam_role.example.id
  name = "s3_access_policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.example.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"                
}

############### Glue Data Catalog ################

resource "aws_glue_catalog_database" "example" {
  name = var.database_name
}

############### Glue Crawler ################

resource "aws_glue_crawler" "example" {
  database_name = aws_glue_catalog_database.example.name
  name          = var.glue_crawler_name
  role          = aws_iam_role.example.arn
  schedule      = var.cron
  s3_target {
    path = "s3://${var.s3_bucket_name}"
  }
}


########### AWS Glue Connection ############
resource "aws_glue_connection" "redshift_connection" {
  name = "redshift-serverless-connection"
  description = "Connection to Redshift Serverless"

  connection_properties = {
    "JDBC_CONNECTION_URL" : "jdbc:redshiftserverless://${aws_redshiftserverless_namespace.example.namespace_name}.${data.aws_redshiftserverless_workgroup.example.endpoint}/${data.aws_redshiftserverless_workgroup.example.database_name}",
    "USERNAME"            : aws_redshiftserverless_namespace.example.admin_username,
    "PASSWORD"            : aws_redshiftserverless_namespace.example.admin_user_password
  }

  physical_connection_requirements {
    availability_zone    = "us-east-1"  # Update with your availability zone
    security_group_id_list = ["sg-12345678"]  # Update with your security group ID
    subnet_id            = "subnet-12345678"  # Update with your subnet ID
  }

  tags = {
    Name = "GlueRedshiftServerlessConnection"
  }
}
