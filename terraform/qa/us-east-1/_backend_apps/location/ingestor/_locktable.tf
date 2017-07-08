###### DynamoDB table to create a lock state ######

resource "aws_dynamodb_table" "locktable" {
  name           = "terraform-sun-b2c-devops-_qa_us-east-1__backend_apps_sun-ms-location-ingestor-locktable"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
