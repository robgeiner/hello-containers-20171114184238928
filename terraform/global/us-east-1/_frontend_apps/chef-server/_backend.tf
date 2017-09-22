# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-global-remote-state-bucket"
    key        = "/global/us-east-1/_frontend_apps/chef-server/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_global_us-east-1__frontend_apps_chef-server-locktable"
    region     = "us-east-1"
  }
}
