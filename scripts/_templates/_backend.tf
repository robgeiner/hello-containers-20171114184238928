# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "REMOTE_STATE_BUCKET_NAME"
    key        = "DIR/terraform.tfstate"
    lock_table = "terraform-OWNER_NAME-DIR_FLAT-locktable"
    region     = "REGION"
  }
}
