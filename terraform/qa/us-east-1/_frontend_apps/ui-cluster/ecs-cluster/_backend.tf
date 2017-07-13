# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_frontend_apps/ui-cluster/ecs-cluster/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev_us-east-1__frontend_apps_ui-cluster_ecs-cluster-locktable"
    region     = "us-east-1"
  }
}
