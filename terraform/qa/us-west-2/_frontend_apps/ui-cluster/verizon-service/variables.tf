variable "version" { default = "7d16c06f49923e800b78cf65861d88b0ecc0beba" }

variable "log_level" {
  default = "info"
}

variable "desired_count" {
  default = "1"
}

variable "asg_min" {
  default = "1"
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
