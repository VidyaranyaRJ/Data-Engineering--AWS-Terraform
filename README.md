To Execute a code follow these steps:
1) Execute S3 Bucket
  terraform init -> terraform plan -> apply
  Step 1: S3 Bucket
  Step 2: A file is uploaded into the bucket
  when we do this it creates a S3 bucket in the US-East-1 region and uploads a .csv file in the bucket.
2) Execute Glue Crawler
  terraform init -> terraform plan -> apply
  Step 1: Created necessary AWS IAM roles for S3 and AWS Glue
  Step 2: Database
  Step 3: Crawler with S3 as Target - Table is created once cron job executs
  when we execute this, it creates necessary IAM roles. Data catalog with a specified database name is ccreated.
  At a specified time (Cron job) it crawls though the .csv file and updates the data catalog table section.
3) Execute Redshift Serverless
  terraform init -> terraform plan -> apply
  Step 1: Namespace with Username & Password
  Step 2: Workgroup
  Step 3: Creates VPC Endpoint Gateway
  When we execute this it creates Redshift Serverless with namespace and workgroup.
4) We manually create a connection to redshift's using username and password. A Table in redshift's dev database is created using the below command.
  example querry:
  create table demo_car_csv
  (
  "car" VARCHAR(256),
  "model"  VARCHAR(256),
  "volume" BIGINT,
  "weight" BIGINT,
  "co2" BIGINT
  );
5) We execute a Glue Connection
  terraform init -> terraform plan -> apply
   Step 1: Glue Connection
  To create a glue connection with redshift we use JDBC_CONNECTION_URL.
6) Move data to Redshift we need create Glue Visual ETL Job - MANUALLY
  Step 1: Select source as S3 bucket
  Step 2: Destination as Redhshift
  Step 3: Specify the job name
  Step 4: select S3 -> S3 source type - Data Catalog table, data base- aws_glue_catalog_database, table - associated with aws_glue_catalog_database, iam role - glue.amazonaws.com. (From this we can see data being populated)
   Step 5: Select Redshift -> Redshift connection- aws_glue_connection, database - dev, schema-public.
   Step 6: save the job.
7)
  Select the juct created job and run.
  After the job is successfull we can see data being populated inside Redshift's dev database.

This is the whole procedure for Data Warehouse (incremental data load from S3 to Redshift using GLue).
