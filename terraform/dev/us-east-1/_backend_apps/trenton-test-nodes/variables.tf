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

variable "ssh_key_name" {
  default = "platform-dev"
}

variable "bastion_private_key" {
  default = "~/.ssh/id_rsa"
}

variable "private_key" {
  default = "~/.ssh/platform-dev.pem"
}
