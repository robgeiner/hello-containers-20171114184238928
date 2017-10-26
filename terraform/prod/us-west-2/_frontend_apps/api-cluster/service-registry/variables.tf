variable "convo_api_name" { default = "convo-api" }
variable "convo_api_port" { default = "8080" }
variable "convo_api_protocol" { default = "HTTP" }
variable "convo_api_priority" { default = "900" }
variable "convo_api_healthcheck_protocol" { default = "HTTP" }
variable "convo_api_healthcheck_path" { default = "/watson-ads-convo/api/v1/systems/health" }
variable "convo_api_global_priority" { default = "100" }
variable "convo_api_region_priority" { default = "101" }

variable "chef_api_name" { default = "chef-api" }
variable "chef_api_port" { default = "8080" }
variable "chef_api_protocol" { default = "HTTP" }
variable "chef_api_priority" { default = "800" }
variable "chef_api_healthcheck_protocol" { default = "HTTP" }
variable "chef_api_healthcheck_path" { default = "/watson-ads-chef/api/v1/systems/health" }
variable "chef_api_global_priority" { default = "200" }
variable "chef_api_region_priority" { default = "201" }
