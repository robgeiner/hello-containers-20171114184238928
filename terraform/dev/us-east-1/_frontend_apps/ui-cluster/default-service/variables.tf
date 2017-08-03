variable "version" { default = "b2a2793613fcd0971a2b372468b340488a5ca58b" }

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
