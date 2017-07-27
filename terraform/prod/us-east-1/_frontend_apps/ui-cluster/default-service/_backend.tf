# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-east-1/_frontend_apps/ui-cluster/default-service/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-east-1__frontend_apps_ui-cluster_default-service-locktable"
    region     = "us-east-1"
  }
}
