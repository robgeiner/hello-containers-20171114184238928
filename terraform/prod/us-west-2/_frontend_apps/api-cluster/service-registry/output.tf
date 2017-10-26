output "external_lb_port" { value = "443" }
output "external_lb_protocol" { value = "HTTPS" }

output "chef_api_name" { value = "${var.chef_api_name}" }
output "chef_api_port" { value = "${var.chef_api_port}" }
output "chef_api_protocol" { value = "${var.chef_api_protocol}" }
output "chef_api_global_priority" { value = "${var.chef_api_global_priority}" }
output "chef_api_region_priority" { value = "${var.chef_api_region_priority}" }
output "chef_api_akamai_priority" { value = "${var.chef_api_akamai_priority}" }
output "chef_api_healthcheck_protocol" { value = "${var.chef_api_healthcheck_protocol}" }
output "chef_api_healthcheck_path" { value = "${var.chef_api_healthcheck_path}" }
output "chef_api_region_hostname" { value = "api-${var.ENVIRONMENT}-${var.REGION}.${data.terraform_remote_state.route53.domain}" }
output "chef_api_global_hostname" { value = "api.${data.terraform_remote_state.route53.domain}" }
output "chef_api_akamai_hostname" { value = "wca-api.sun-api.akadns.net" }


output "convo_api_name" { value = "${var.convo_api_name}" }
output "convo_api_port" { value = "${var.convo_api_port}" }
output "convo_api_protocol" { value = "${var.convo_api_protocol}" }
output "convo_api_global_priority" { value = "${var.convo_api_global_priority}" }
output "convo_api_region_priority" { value = "${var.convo_api_region_priority}" }
output "convo_api_akamai_priority" { value = "${var.convo_api_akamai_priority}" }
output "convo_api_healthcheck_protocol" { value = "${var.convo_api_healthcheck_protocol}" }
output "convo_api_healthcheck_path" { value = "${var.convo_api_healthcheck_path}" }
output "convo_api_region_hostname" { value = "${var.convo_api_name}-${var.ENVIRONMENT}-${var.REGION}.${data.terraform_remote_state.route53.domain}" }
output "convo_api_global_hostname" { value = "${var.convo_api_name}.${data.terraform_remote_state.route53.domain}" }
output "convo_api_akamai_hostname" { value = "wca-convo-api.sun-api.akadns.net" }
