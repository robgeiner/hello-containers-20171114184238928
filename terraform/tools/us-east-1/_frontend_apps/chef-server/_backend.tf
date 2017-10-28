# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-tools-remote-state-bucket"
    key        = "/tools/us-east-1/_frontend_apps/chef-server/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_tools_us-east-1__frontend_apps_chef-server-locktable"
    region     = "us-east-1"
  }
}
