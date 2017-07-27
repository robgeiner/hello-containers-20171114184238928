###### DynamoDB table to create a lock state ######

resource "aws_dynamodb_table" "locktable" {
  name           = "terraform-cognitive-devops-_prod_us-east-1__core_logging_es-proxy-locktable"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
