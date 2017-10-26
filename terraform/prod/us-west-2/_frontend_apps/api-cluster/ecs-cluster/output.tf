output "alb_public_dns_name" {
  value = "${module.alb-public.dns_name}"
}

output "alb_public_zone_id" {
  value = "${module.alb-public.zone_id}"
}

output "alb_public_arn" {
  value = "${module.alb-public.arn}"
}

output "listener_public_arn" {
  value = "${aws_alb_listener.public-listener.arn}"
}

output "cluster_id" {
  value = "${module.cluster.id}"
}

output "cluster_name" {
  value = "${module.cluster.name}"
}

output "cluster_short_name" {
  value = "${var.cluster_short_name}"
}

output "convo_api_dns_name" {
  value = "${aws_route53_record.cogads-convo-api.fqdn}"
}

output "chef_api_dns_name" {
  value = "${aws_route53_record.cogads-chef-api.fqdn}"
}
