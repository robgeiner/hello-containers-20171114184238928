variable "app_version" { default = "f8060599a124b027c16b4c37c08a41aea9d4884b" }

variable "config_version" { default = "7b0933ac5c5d0a4a565a21b95975d9ccefb8a37e" }

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
  default = "false"
}

variable "config_path" {
  default = "/config/instance_configurations"
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

variable "CONVERSATION_USER" {}
variable "CONVERSATION_PW" {}

variable "personality_insights_url" {
  default = "https://gateway.watsonplatform.net/personality-insights/api"
}
variable "PERSONALITY_INSIGHTS_USER" {}
variable "PERSONALITY_INSIGHTS_PW" {}

variable "rank_and_retrieve_url" {
  default = "https://gateway.watsonplatform.net/retrieve-and-rank/api"
}
variable "RNR_USER" {}
variable "RNR_PW" {}

variable "TONE_ANALYZER_USER" {}
variable "TONE_ANALYZER_PW" {}
variable "tone_analyzer_url" {
  default = "https://gateway.watsonplatform.net/tone-analyzer/api"
}
variable "tone_analyzer_version_date" {
  default = "2016-05-19"
}

variable "WEATHER_API_KEY" {}

variable "NEW_RELIC_LICENSE_KEY" {}
