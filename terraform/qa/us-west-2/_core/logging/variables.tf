variable "elasticsearch_version"{
  default = "5.3"
}

variable "volume_type"{
  default = "gp2"
}

variable "volume_size"{
  default = 50
}

variable "instance_type" {
  description = "type of instance to launch elasticsearch"
  default = "m3.large.elasticsearch"
}

variable "instance_count"{
  default = 2
}

variable "dedicated_master_type"{
  default = "m3.large.elasticsearch"
}

variable "dedicated_master_count"{
  default = 2
}
