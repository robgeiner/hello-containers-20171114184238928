# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "sun-b2c-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_backend_apps/location/postgresql/terraform.tfstate"
    lock_table = "terraform-sun-b2c-devops-_dev_us-east-1__backend_apps_location_postgresql-locktable"
    region     = "us-east-1"
  }
}
