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


