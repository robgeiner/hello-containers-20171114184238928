variable "vpc_cog_cidr" {
  default = "10.2.0.0/16"
}

variable "vpc_cog_public_subnet_cidrs" {
  default = ["10.2.8.0/24", "10.2.7.0/24", "10.2.6.0/24"]
  type = "list"
}

variable "vpc_cog_private_subnet_cidrs" {
  default = ["10.2.11.0/24", "10.2.10.0/24", "10.2.9.0/24"]
  type = "list"
}

variable "vpc_cog_zones" {
  default = [ "d", "c", "b" ]
  type = "list"
}
