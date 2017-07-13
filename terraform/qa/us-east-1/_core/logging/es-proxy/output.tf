output "dns_name" {
  value = "${aws_route53_record.es-proxy_ext_elb.name}"
}
