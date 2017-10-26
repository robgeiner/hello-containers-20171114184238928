# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-west-2/_frontend_apps/api-cluster/ecs-cluster/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-west-2__frontend_apps_api-cluster_ecs-cluster-locktable"
    region     = "us-east-1"
  }
}
