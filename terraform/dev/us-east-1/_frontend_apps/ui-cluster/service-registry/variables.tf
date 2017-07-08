variable "default_name" { default = "default" }
variable "default_port" { default = "8080" }
variable "default_protocol" { default = "HTTP" }
variable "default_priority" { default = "900" }
variable "default_path" { default = "/*" }
variable "default_healthcheck_protocol" { default = "HTTP" }
variable "default_healthcheck_path" { default = "/wa/health" }

variable "verizon_name" { default = "verizon" }
variable "verizon_port" { default = "3001" }
variable "verizon_protocol" { default = "HTTP" }
variable "verizon_priority" { default = "100" }
variable "verizon_path" { default = "/wa/9e1917ed-4158-4435-a1db-7a78f97ee395*" }
variable "verizon_healthcheck_protocol" { default = "HTTP" }
variable "verizon_healthcheck_path" { default = "/wa/health" }
