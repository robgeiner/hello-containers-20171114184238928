variable "ecs-cluster-ami" {
  default = "ami-cde15eb7"
}

variable "cluster_short_name" {
  default = "ui"
}

variable "asg_min" {
  default = "2"
}

variable "asg_max" {
  default = "4"
}

variable "chef_role" {
  default = "ecs-ads"
}

variable "chef_version" {
   default = "12.16.42"
}

variable "instance_type" {
  default = "m4.large"
}

# for websocket connections
variable "idle_timeout" {
  default = "300"
}

variable "config_file" {
  default = "false"
}

variable "docker_version" {
  default = "17.03.1"
}

variable "docker_debug" {
  default = "false"
}

variable "monitoring_agent_version" {
  default = "12.4.5181-alpine"
}

variable "ecs_agent_version" {
  default = "v1.14.5"
}

variable "ecs_agent_log_level" {
  default = "info"
}

variable "logmet_install" {
  default = "false"
}

variable "logmet_host" {
  default = "logs.ibm4.opvis.bluemix.net"
}

variable "MONITORING_AGENT" {
}

variable "MONITORING_AGENT_KEY" {
}

variable "LOGMET_LOGGING_TOKEN" {
 default = "notset"
}

variable "LOGMET_SPACE_ID" {
default = "notset"
}

variable "REPOSITORY_AUTH_DATA_URL" {
}

variable "REPOSITORY_AUTH_DATA_USERNAME" {
}

variable "REPOSITORY_AUTH_DATA_PASSWORD" {
}

variable "REPOSITORY_AUTH_DATA_EMAIL" {
}
