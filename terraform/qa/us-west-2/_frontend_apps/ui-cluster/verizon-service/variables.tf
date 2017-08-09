variable "version" { default = "4ab876a0a5bf4d44dd0a6ae2bc299b4637d0c64e" }

variable "log_level" {
  default = "info"
}

variable "desired_count" {
  default = "2"
}

variable "deployment_minimum_healthy_percent" {
  default = "50"
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

variable "TWITTER_CONSUMER_KEY" {}

variable "TWITTER_CONSUMER_SECRET" {}
