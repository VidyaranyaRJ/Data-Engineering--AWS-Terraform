To Execute a code follow these steps:
Step 1: Execute S3 Bucket
  terraform init -> terraform plan -> apply
  1) S3 Bucket
  2) A file is uploaded into the bucket
  when we do this it creates a S3 bucket in the US-East-1 region and uploads a .csv file in the bucket.
Step 2: Execute Glue Crawler
  terraform init -> terraform plan -> apply
  1) Created necessary AWS IAM roles for S3 and AWS Glue
  2) Database
  3) Crawler with S3 as Target - Table is created once cron job executs
  when we execute this, it creates necessary IAM roles. Data catalog with a specified database name is ccreated.
  At a specified time (Cron job) it crawls though the .csv file and updates the data catalog table section.
Step 3: Execute Redshift Serverless
  terraform init -> terraform plan -> apply
  1) Namespace with Username & Password
  2) Workgroup
  3) Creates VPC Endpoint Gateway
  When we execute this it creates Redshift Serverless with namespace and workgroup.
Step 4: We manually create a connection to redshift's using username and password. A Table in redshift's dev database is created using the below command.
  example querry:
  create table demo_car_csv
  (
  "car" VARCHAR(256),
  "model"  VARCHAR(256),
  "volume" BIGINT,
  "weight" BIGINT,
  "co2" BIGINT
  );
Step 5: We execute a Glue Connection
  terraform init -> terraform plan -> apply
  1) Glue Connection
  To create a glue connection with redshift we use JDBC_CONNECTION_URL.
Step 6: Move data to Redshift we need create Glue Visual ETL Job - MANUALLY
  1) Select source as S3 bucket
  2) Destination as Redhshift
  3) Specify the job name
  4) select S3 -> S3 source type - Data Catalog table, data base- aws_glue_catalog_database, table - associated with aws_glue_catalog_database, iam role - glue.amazonaws.com. (From this we can see data being populated)
  5) Select Redshift -> Redshift connection- aws_glue_connection, database - dev, schema-public.
  6) save the job.
Step 7:
  Select the juct created job and run.
  After the job is successfull we can see data being populated inside Redshift's dev database.

This is the whole procedure for Data Warehouse (incremental data load from S3 to Redshift using GLue).
