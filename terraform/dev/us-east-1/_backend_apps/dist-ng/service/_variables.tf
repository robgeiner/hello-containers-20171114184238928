#######################################################################
# Empty Variables defined by terragrunt-runner.sh, don't modify these!
#######################################################################
variable "OWNER_NAME" {}
variable "REMOTE_STATE_BUCKET_NAME" {}
variable "REGION" {}
variable "ENVIRONMENT" {}
variable "CHEF_VALIDATION_CLIENT_NAME" {}
variable "CHEF_VALIDATION_KEY_PATH" {}
variable "CHEF_SERVER_URL" {}
variable "SUN_MANAGED_STATE_BUCKET" {}
variable "SUN_MANAGED_STATE_KEY" {}
variable "SUN_MANAGED_STATE_REGION" {}
variable "SSH_KEY_NAME" {}
variable "REMOTE_STATE_BUCKET_REGION" {}
#######################################################################
variable "environment" {
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}

variable "validation_key_path" {
  default = "~/.chef/platform-validator.pem"
}

variable "zone_id" {
  default = "Z1T5DRRJ1108TF"
}

variable "validation_client_name" {
  default = "platform-validator"
}
/*
variable "ssh_key_name" {
  default = "platform-dev"
}
*/

variable "billing" { 
  default = "SUN" 
}

variable "tags" {
  default = { 
    "Owner" = "b2c"
    "Team" = "b2c"
    "Skip-Zabbix" = "True" 
    }
}
