variable "environment" {
  default = "qa"
}

variable "region" {
  default = "us-east-1"
}

variable "validation_key_path" {
  default = "~/.chef/platform-validator.pem"
}

variable "zone_id" {
  default = "ZB9HMAAB4ZXDV"
}

variable "validation_client_name" {
  default = "platform-validator"
}

variable "ssh_key_name" {
  default = "platform-qa"
}

variable "bastion_private_key" {
  default = "~/.ssh/id_rsa"
}

variable "private_key" {
  default = "~/.ssh/platform-qa.pem"
}

variable "instance_count" {
  default = "2"
}
