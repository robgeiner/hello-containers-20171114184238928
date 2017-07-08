output "vpc_id" {
  value = "${data.terraform_remote_state.vpc.vpc_id}"
}

output "basic_access_sg_id" {
  value = "${data.terraform_remote_state.vpc.basic_access_sg}"
}

output "internal_sg_id" {
  value = "${data.terraform_remote_state.vpc.internal_sg}"
}

output "public_1_subnet_ids" {
  value = "${data.terraform_remote_state.vpc.public_1_ids}"
}

output "public_1_subnet_zones" {
  value = "${data.terraform_remote_state.vpc.public_1_zones}"
}

output "public_2_subnet_ids" {
  value = "${data.terraform_remote_state.vpc.public_2_ids}"
}

output "public_2_subnet_zones" {
  value = "${data.terraform_remote_state.vpc.public_2_zones}"
}

output "private_1_subnet_ids" {
  value = "${data.terraform_remote_state.vpc.private_1_ids}"
}

output "private_1_subnet_zones" {
  value = "${data.terraform_remote_state.vpc.private_1_zones}"
}

output "private_2_subnet_ids" {
  value = "${data.terraform_remote_state.vpc.private_2_ids}"
}

output "private_2_subnet_zones" {
  value = "${data.terraform_remote_state.vpc.private_2_zones}"
}
