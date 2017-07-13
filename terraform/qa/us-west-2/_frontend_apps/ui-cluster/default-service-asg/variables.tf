variable "chef-ui-ami" {
  default = "ami-d7ecdec1"
}

variable "chef-ui-lc" {
  default = "chef-ui-"
}

variable "environment" {
  default = "nonprod"
}

variable "chef-ui-asg-max" {
  default = "2"
}

variable "chef-ui-asg-min" {
  default = "2"
}

variable "chef_version" {
  default = "12.13.37"
}
