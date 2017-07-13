variable "cache_identifier" {
  default = "session"
}

variable "port" {
  default = "6379"
}

variable "instance_type" {
  default = "cache.m4.large"
}

variable "cluster_count" {
  default = "2"
}

variable "engine_version" {
  default = "3.2.4"
}

variable "parameter_group" {
  default = "default.redis3.2"
}

variable "automatic_failover" {
  default = "true"
}

variable "alarm_memory_threshold" {
  default = "10000000"
}

variable "alarm_cpu_threshold" {
  default = "75"
}
