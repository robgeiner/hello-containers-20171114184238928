# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-west-2/_frontend_apps/api-cluster/repository/chef-api/app/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-west-2__frontend_apps_api-cluster_repository_chef-api_app-locktable"
    region     = "us-east-1"
  }
}
