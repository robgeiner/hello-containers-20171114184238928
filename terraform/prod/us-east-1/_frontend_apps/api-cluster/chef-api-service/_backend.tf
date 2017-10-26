# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-east-1/_frontend_apps/api-cluster/chef-api-service/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-east-1__frontend_apps_api-cluster_chef-api-service-locktable"
    region     = "us-east-1"
  }
}
