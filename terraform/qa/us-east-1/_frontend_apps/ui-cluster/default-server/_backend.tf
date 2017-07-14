# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-east-1/_frontend_apps/ui-cluster/default-server/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-east-1__frontend_apps_ui-cluster_default-server-locktable"
    region     = "us-east-1"
  }
}
