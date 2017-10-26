# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-east-1/_frontend_apps/api-cluster/repository/convo-api/config/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-east-1__frontend_apps_api-cluster_repository_convo-api_config-locktable"
    region     = "us-east-1"
  }
}
