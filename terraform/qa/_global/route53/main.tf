resource "aws_route53_record" "cogads-ui" {
  zone_id = "${var.zone_id}"
  name = "ui"
  type = "CNAME"
  ttl = "60"
  records = ["wca-ui-qa.sun-api.akadns.net"]
}

resource "aws_route53_record" "cogads-convo-api" {
  zone_id = "${var.zone_id}"
  name = "convo-api"
  type = "CNAME"
  ttl = "60"
  records = ["wca-convo-api-qa.sun-api.akadns.net"]
}
