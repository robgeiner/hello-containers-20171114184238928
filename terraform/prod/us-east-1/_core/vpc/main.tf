###############################################################################################################################################################################################
###  Cognitive VPC:  Unmanaged CIDR group.  This means that instances within this group can NOT talk to instances in other VPCs. They will need to use public endpoints to do so
###############################################################################################################################################################################################
module "cog_iso_vpc" {
  source                = "git::ssh://git@github.com/TheWeatherCompany/tf_aws_vpc_advanced.git?ref=v2.0.1"
  vpc_name              = "${var.PROJECT}-${var.ENVIRONMENT}-${var.REGION}-vpc"
  vpc_cidr              = "${var.vpc_cog_cidr}"
  public_subnet_cidrs   = "${var.vpc_cog_public_subnet_cidrs}"
  private_subnet_cidrs  = "${var.vpc_cog_private_subnet_cidrs}"
  private_subnet_azs    = "${var.vpc_cog_zones}"
  public_subnet_azs     = "${var.vpc_cog_zones}"
  tier                  = "${var.ENVIRONMENT}"

 #TODO:  WTH is the remote state not working for just this attribute

#  region                = "${var.REGION}"
  region                = "${var.REGION}"
  product_name          = "${var.PROJECT}"
}
