resource "aws_route53_record" "cogads-ui" {
  zone_id = "${var.zone_id}"
  name = "ui"
  type = "CNAME"
  ttl = "60"
  records = ["ui-dev-us-east-1.dev.cogads.weather.com"]
}

resource "aws_route53_record" "cogads-convo-api" {
  zone_id = "${var.zone_id}"
  name = "convo-api"
  type = "CNAME"
  ttl = "60"
  records = ["convo-api-dev-us-east-1.dev.cogads.weather.com"]
}
