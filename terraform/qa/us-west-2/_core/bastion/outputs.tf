output "bastion_public_dns" {
  value = "${module.bastion.bastion_public_dns}"
}

output "bastion_public_ip" {
  value = "${module.bastion.bastion_public_ip}"
}

output "bastion_private_ip" {
  value = "${module.bastion.bastion_private_ip}"
}

output "bastion_security_group_id" {
  value = "${module.bastion.bastion_security_group_id}"
}

output "bastion_security_group_name" {
  value = "${module.bastion.bastion_security_group_name}"
}

output "basic_access_security_group_id" {
  value = "${module.bastion.basic_access_security_group_id}"
}
