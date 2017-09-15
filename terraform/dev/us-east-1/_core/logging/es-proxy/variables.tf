variable "asg_max" {
  default = "1"
}

variable "asg_min" {
  default = "1"
}

variable "chef_version" {
  default = "12.13.37"
}

variable "chef_role" {
  default = "base-ads"
}

variable "instance_type" {
  default = "t2.medium"
}

#variable "additional_ips" {
#   default = "71.0.127.137/32"  # rob geiner home
#}  # dev/devops home static ips
