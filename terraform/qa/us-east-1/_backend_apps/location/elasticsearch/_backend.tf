# backend config, don't change

terraform {
 backend "s3" {
   bucket = "sun-b2c-devops-qa-remote-state-bucket"
   key = "/qa/us-east-1/_backend_apps/sun-ms-location-elasticsearch/terraform.tfstate"
   lock_table = "terraform-sun-b2c-devops-_qa_us-east-1__backend_apps_sun-ms-location-elasticsearch-locktable"
   region = "us-east-1"
 }
}
