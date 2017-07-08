variable "oapi-monolith-varnish-ami" {
  default = "ami-12c6b104"
}

variable "oapi-monolith-varnish-asg-min" {
  default = "1"
}

variable "oapi-monolith-varnish-asg-max" {
  default = "2"
}

variable "oapi-monolith-varnish-lc-prefix" {
  default = "oapi-monolith-varnish-"
}

variable "oapi-monolith-varnish-size" {
  default = "r4.large"
}
