variable "version" { default = "ffb3ef3b2b12f278247dbc7c84fbbab0d9b49272" }

variable "log_level" {
  default = "info"
}

variable "desired_count" {
  default = "2"
}

variable "deployment_minimum_healthy_percent" {
  default = "50"
}

variable "deployment_maximum_percent" {
  default = "200"
}

variable "asg_min" {
  default = "2"
}

variable "asg_max" {
  default = "4"
}

variable "cpu" {
  default = "100"
}

variable "memory" {
  default = "256"
}

variable "port" {
  default = "9000"
}

variable "profiler" {
  default = "false"
}

variable "background" {
  default = "false"
}

variable "NEW_RELIC_LICENSE_KEY" {}
