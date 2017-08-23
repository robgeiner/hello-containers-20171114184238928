# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_frontend_apps/ui-cluster/repository/convo-api/app/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev_us-east-1__frontend_apps_ui-cluster_repository_convo-api_app-locktable"
    region     = "us-east-1"
  }
}
