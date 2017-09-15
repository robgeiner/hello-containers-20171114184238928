variable "default_name" { default = "default" }
variable "default_port" { default = "8080" }
variable "default_protocol" { default = "HTTP" }
variable "default_priority" { default = "900" }
variable "default_api_key" { default = "*"  }
variable "default_path" { default = "/wa/" }
variable "default_healthcheck_protocol" { default = "HTTP" }
variable "default_healthcheck_path" { default = "/wa/health" }

variable "verizon_name" { default = "verizon" }
variable "verizon_port" { default = "3001" }
variable "verizon_protocol" { default = "HTTP" }
variable "verizon_priority" { default = "200" }
variable "verizon_api_key" { default = "9e1917ed-4158-4435-a1db-7a78f97ee395"  }
variable "verizon_path" { default = "/wa/" }
variable "verizon_healthcheck_protocol" { default = "HTTP" }
variable "verizon_healthcheck_path" { default = "/wa/health" }

variable "hulu_name" { default = "hulu" }
variable "hulu_port" { default = "3002" }
variable "hulu_protocol" { default = "HTTP" }
variable "hulu_priority" { default = "210" }
variable "hulu_api_key" { default = "20c56a22-45d3-45d1-b133-306845bb9b1b"  }
variable "hulu_path" { default = "/wa/" }
variable "hulu_healthcheck_protocol" { default = "HTTP" }
variable "hulu_healthcheck_path" { default = "/wa/health" }

variable "convo_api_name" { default = "convo-api" }
variable "convo_api_port" { default = "8080" }
variable "convo_api_protocol" { default = "HTTP" }
variable "convo_api_priority" { default = "900" }
variable "convo_api_api_key" { default = "*"  }
variable "convo_api_path" { default = "/watson-ads-convo/" }
variable "convo_api_healthcheck_protocol" { default = "HTTP" }
variable "convo_api_healthcheck_path" { default = "/watson-ads-convo/api/v1/systems/health" }
variable "convo_api_global_priority" { default = "100" }
variable "convo_api_region_priority" { default = "101" }
