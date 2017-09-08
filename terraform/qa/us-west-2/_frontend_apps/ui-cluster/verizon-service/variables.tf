variable "version" { default = "fcdcd7ea4e8c2c6c9f548d4df82b520c785f367d" }

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

variable "storage" {
  default = "REDIS"
}

variable "debug_options" {
  default = ""
  #default = "connect:redis,express-session"
}

variable "profiler" {
  default = "false"
}

variable "background" {
  default = "false"
}

variable "NEW_RELIC_LICENSE_KEY" {}

variable "TWITTER_CONSUMER_KEY" {}

variable "TWITTER_CONSUMER_SECRET" {}
