resource "aws_route53_record" "cogads-ui" {
  zone_id = "${var.zone_id}"
  name = "ui"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.ui-service-registry.ui_akamai_hostname}"]
}

resource "aws_route53_record" "cogads-convo-api" {
  zone_id = "${var.zone_id}"
  name = "convo-api"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.api-service-registry.convo_api_akamai_hostname}"]
}

resource "aws_route53_record" "cogads-chef-api" {
  zone_id = "${var.zone_id}"
  name = "api"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.api-service-registry.chef_api_akamai_hostname}"]
}
