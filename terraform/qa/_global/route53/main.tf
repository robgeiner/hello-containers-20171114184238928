resource "aws_route53_record" "cogads-ui-shortname" {
  zone_id = "${var.zone_id}"
  name = "ui"
  type = "CNAME"
  ttl = "60"
  records = ["wca-ui-qa.sun-api.akadns.net"]
}
