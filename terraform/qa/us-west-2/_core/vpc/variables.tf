variable "vpc_cog_cidr" {
  default = "10.3.0.0/16"
}

variable "vpc_cog_public_subnet_cidrs" {
  default = ["10.3.8.0/24", "10.3.7.0/24", "10.3.6.0/24"]
  type = "list"
}

variable "vpc_cog_private_subnet_cidrs" {
  default = ["10.3.11.0/24", "10.3.10.0/24", "10.3.9.0/24"]
  type = "list"
}

variable "vpc_cog_zones" {
  default = [ "d", "c", "b" ]
  type = "list"
}
