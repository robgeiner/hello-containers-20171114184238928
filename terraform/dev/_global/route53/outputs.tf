output "zone_id" {
  value = "${var.zone_id}"
}

output "domain" {
  value = "${var.domain}"
}

output "certificate_arn" {
  value = "${var.certificate_arn}"
}

output "cogads_ui_dns_name" {
  value = "${aws_route53_record.cogads-ui.fqdn}"
}

output "cogads_convo_api_dns_name" {
  value = "${aws_route53_record.cogads-convo-api.fqdn}"
}

output "cogads_chef_api_dns_name" {
  value = "${aws_route53_record.cogads-chef-api.fqdn}"
}
