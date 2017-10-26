resource "aws_route53_record" "cogads-ui" {
  zone_id = "${var.zone_id}"
  name = "ui"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.ui_useast1.ui_dns_name}"]
}

resource "aws_route53_record" "cogads-convo-api" {
  zone_id = "${var.zone_id}"
  name = "convo-api"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.api_useast1.convo_api_dns_name}"]
}

resource "aws_route53_record" "cogads-chef-api" {
  zone_id = "${var.zone_id}"
  name = "api"
  type = "CNAME"
  ttl = "60"
  records = ["${data.terraform_remote_state.api_useast1.chef_api_dns_name}"]
}
