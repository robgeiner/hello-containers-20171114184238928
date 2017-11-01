output "external_lb_port" { value = "443" }
output "external_lb_protocol" { value = "HTTPS" }

output "default_name" { value = "${var.default_name}" }
output "default_port" { value = "${var.default_port}" }
output "default_protocol" { value = "${var.default_protocol}" }
output "default_priority" { value = "${var.default_priority}" }
output "default_api_key" { value = "${var.default_api_key}" }
output "default_path" { value = "${var.default_path}" }
output "default_healthcheck_protocol" { value = "${var.default_healthcheck_protocol}" }
output "default_healthcheck_path" { value = "${var.default_healthcheck_path}" }

output "verizon_name" { value = "${var.verizon_name}" }
output "verizon_port" { value = "${var.verizon_port}" }
output "verizon_protocol" { value = "${var.verizon_protocol}" }
output "verizon_priority" { value = "${var.verizon_priority}" }
output "verizon_api_key" { value = "${var.verizon_api_key}" }
output "verizon_path" { value = "${var.verizon_path}" }
output "verizon_healthcheck_protocol" { value = "${var.verizon_healthcheck_protocol}" }
output "verizon_healthcheck_path" { value = "${var.verizon_healthcheck_path}" }

output "hulu_name" { value = "${var.hulu_name}" }
output "hulu_port" { value = "${var.hulu_port}" }
output "hulu_protocol" { value = "${var.hulu_protocol}" }
output "hulu_priority" { value = "${var.hulu_priority}" }
output "hulu_api_key" { value = "${var.hulu_api_key}" }
output "hulu_path" { value = "${var.hulu_path}" }
output "hulu_healthcheck_protocol" { value = "${var.hulu_healthcheck_protocol}" }
output "hulu_healthcheck_path" { value = "${var.hulu_healthcheck_path}" }
