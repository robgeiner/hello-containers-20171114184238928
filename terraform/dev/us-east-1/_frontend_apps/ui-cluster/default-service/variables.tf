variable "version" { default = "84e6e6a5763d0c028ea792cb88a37386ee0da70e" }

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
