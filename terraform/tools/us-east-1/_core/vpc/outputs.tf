output "vpc_id" {
  value = "${module.cog_iso_vpc.vpc_id}"
}

output "public_subnet_ids" {
  value = "${module.cog_iso_vpc.public_subnet_ids}"
}

output "private_subnet_ids" {
  value = "${module.cog_iso_vpc.private_subnet_ids}"
}

output "public_subnet_zones" {
  value = "${var.vpc_cog_zones}"
}

output "private_subnet_zones" {
  value = "${var.vpc_cog_zones}"
}

output "availability_zones" {
  value = "${var.vpc_cog_zones}"
}

output "region_obj" {
  value = "${var.REGION}"
}

output "region_local" {
  value = "${var.REGION}"
}

output "vpc_public_subnet_cidrs" {
  value =  "${var.vpc_cog_public_subnet_cidrs}"
}

output "vpc_private_subnet_cidrs" {
  value = "${var.vpc_cog_private_subnet_cidrs}"
}
