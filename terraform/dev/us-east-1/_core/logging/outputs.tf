output "endpoint" {
  value = "${aws_elasticsearch_domain.logging.endpoint}"
}

output "domain_id" {
  value = "${aws_elasticsearch_domain.logging.domain_id}"
}

output "arn" {
  value = "${aws_elasticsearch_domain.logging.arn}"
}

output "region" {
  value = "${var.REGION}"
}
