output "replication_group_id" {
  value = "${module.redis-cache.replication_group_id}"
}

output "endpoint" {
  value = "${module.redis-cache.endpoint}"
}

output "port" {
  value = "${var.port}"
}

output "configuration_endpoint_address" {
  value = "${module.redis-cache.configuration_endpoint_address}"
}
