variable "app_version" { default = "bdb76566fdaeee988982d72a991362acf6392246" }

variable "config_version" { default = "8526d95fb89107bd8f68b7f595f9677cd3e547d9" }

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

variable "WEATHER_API_KEY" {}
