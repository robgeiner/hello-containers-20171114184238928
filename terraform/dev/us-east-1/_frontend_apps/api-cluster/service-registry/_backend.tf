# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_frontend_apps/api-cluster/service-registry/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev_us-east-1__frontend_apps_api-cluster_service-registry-locktable"
    region     = "us-east-1"
  }
}
