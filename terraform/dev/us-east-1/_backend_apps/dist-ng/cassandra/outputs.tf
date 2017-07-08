output "cassandra_public_ip" {
  value = "${module.dist-ng-cassandra.publicip}"
}

output "cassandra_private_ip" {
  value = "${module.dist-ng-cassandra.privateip}"
}
