###### DynamoDB table to create a lock state ######

resource "aws_dynamodb_table" "locktable" {
  name           = "terraform-cognitive-devops-_qa_us-east-1__frontend_apps_ui-cluster_default-server-locktable"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
