data "terraform_remote_state" "sun-managed-qa-us-east-1" {
  backend = "s3"
  config {
    bucket = "sun-managed-qa-us-east-1-remote-state-bucket"
    key = "config-qa-us-east-1/terraform.tfstate"
    region = "us-east-1"
  }
}
