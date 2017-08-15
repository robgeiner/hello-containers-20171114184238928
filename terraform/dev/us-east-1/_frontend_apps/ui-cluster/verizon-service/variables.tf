variable "version" { default = "06cc0be9305857463f8238d70876c7829ffbe268" }

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

variable "TWITTER_CONSUMER_KEY" {}

variable "TWITTER_CONSUMER_SECRET" {}
