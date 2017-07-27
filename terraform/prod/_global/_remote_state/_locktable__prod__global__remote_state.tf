###### DynamoDB table to create a lock state ######

resource "aws_dynamodb_table" "locktable" {
  name           = "terraform-cognitive-devops-_prod__global__remote_state-locktable"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
