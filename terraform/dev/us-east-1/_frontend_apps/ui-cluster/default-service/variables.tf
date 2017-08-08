variable "version" { default = "e0201c9444284bad5904402e6885c8bbb34fcff0" }

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

variable "profiler" {
  default = "false"
}

variable "background" {
  default = "false"
}
