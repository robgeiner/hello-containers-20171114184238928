variable "version" { default = "e6d74862fafdb6833d031569be15d26f3af17775" }

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

variable "download_s3_files" {
  default = "true"
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
variable "CONVO_API_USERNAME" {}
variable "CONVO_API_PASSWORD" {}
variable "SPEECH_TO_TEXT_USERNAME" {}
variable "SPEECH_TO_TEXT_PASSWORD" {}
variable "PERSONALITY_INSIGHTS_USERNAME" {}
variable "PERSONALITY_INSIGHTS_PASSWORD" {}
variable "RETRIEVE_AND_RANK_USERNAME" {}
variable "RETRIEVE_AND_RANK_PASSWORD" {}
