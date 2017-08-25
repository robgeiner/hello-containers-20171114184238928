variable "version" { default = "e91c5b22b4407d0ccf7a77e4091b3117ff52ba69" }

variable "log_level" {
  default = "info"
}

variable "desired_count" {
  default = "2"
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

variable "profiler" {
  default = "false"
}

variable "background" {
  default = "false"
}

variable "debug_options" {
  default = ""
  #default = "connect:redis,express-session"
}

variable "NEW_RELIC_LICENSE_KEY" {}

variable "TWITTER_CONSUMER_KEY" {}

variable "TWITTER_CONSUMER_SECRET" {}
