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
  records = ["chef-api-dev-us-east-1-standalone.dev.cogads.weather.com"]
}

#resource "aws_route53_record" "cogads-chef-api" {
#  zone_id = "${var.zone_id}"
#  name = "api"
#  type = "CNAME"
#  ttl = "60"
#  records = ["chef-api-dev-us-east-1-standalone.dev.cogads.weather.com"]
#}
