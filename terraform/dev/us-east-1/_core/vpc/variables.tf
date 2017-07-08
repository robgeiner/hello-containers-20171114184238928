variable "vpc_cog_cidr" {
  default = "10.1.0.0/16"
}

variable "vpc_cog_public_subnet_cidrs" {
  default = ["10.1.8.0/24", "10.1.7.0/24", "10.1.6.0/24"]
  type = "list"
}

variable "vpc_cog_private_subnet_cidrs" {
  default = ["10.1.11.0/24", "10.1.10.0/24", "10.1.9.0/24"]
  type = "list"
}

variable "vpc_cog_zones" {
  default = [ "d", "c", "b" ]
  type = "list"
}
