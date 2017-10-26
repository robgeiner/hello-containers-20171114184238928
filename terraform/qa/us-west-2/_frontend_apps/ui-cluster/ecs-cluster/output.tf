output "alb_public_dns_name" {
  value = "${module.alb-public.dns_name}"
}

output "alb_public_zone_id" {
  value = "${module.alb-public.zone_id}"
}

output "alb_public_arn" {
  value = "${module.alb-public.arn}"
}

output "tg_default_arn" {
  value = "${module.default-tg.arn}"
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

output "ui_dns_name" {
  value = "${aws_route53_record.cogads-ui.fqdn}"
}
