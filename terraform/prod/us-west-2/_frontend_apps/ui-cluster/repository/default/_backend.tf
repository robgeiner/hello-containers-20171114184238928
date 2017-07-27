# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-west-2/_frontend_apps/ui-cluster/repository/default/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-west-2__frontend_apps_ui-cluster_repository_default-locktable"
    region     = "us-east-1"
  }
}
