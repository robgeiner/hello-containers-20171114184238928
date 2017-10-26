# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-west-2/_frontend_apps/api-cluster/convo-api-service/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-west-2__frontend_apps_api-cluster_convo-api-service-locktable"
    region     = "us-east-1"
  }
}
