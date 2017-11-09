variable "app_version" { default = "c3c0f11ecf08ce65cb750c673fe7e1c56be052fb" }

variable "log_level" {
  default = "info"
}

variable "desired_count" {
  default = "2"
}

variable "restart_count" { default = "not-set" }

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

variable "debug_options" {
  default = ""
  #default = "connect:redis,express-session"
}

variable "BAR_QUEUE_ARN" {}
variable "BAR_QUEUE_NAME" {}
variable "BAR_READ_ACCESS_KEY" {}
variable "BAR_READ_SECRET_KEY" {}
variable "BAR_READ_USER" {}
variable "BAR_WRITE_ACCESS_KEY" {}
variable "BAR_WRITE_SECRET_KEY" {}
variable "BAR_WRITE_USER" {}
variable "BAR_STREAM_ACCESS_KEY" {}
variable "BAR_STREAM_ACCESS_SECRET" {}

variable "WEATHER_API_KEY" {}

variable "NEW_RELIC_LICENSE_KEY" {}

variable "CHEF_BE_USERNAME" {}
variable "CHEF_BE_PASSWORD" {}


variable "hostnames" {
  default = {
    dev = "nonprod-useast1-ext-lb.dev.cogads.weather.com/IronChefUI/jaxrs/"
    qa = "qa-useast1-ext-lb.qa.cogads.weather.com/IronChefUI/jaxrs/"
    prod = "prod-useast1-ext-lb.cogads.weather.com/IronChefUI/jaxrs/"
  }
}

variable "image_roots" {
  default = {
    dev = "https://dsx-int.weather.com/util/image/wca/"
    qa = "https://dsx-stage.weather.com/util/image/wca/"
    prod = "https://dsx.weather.com/util/image/wca/"
  }
}
