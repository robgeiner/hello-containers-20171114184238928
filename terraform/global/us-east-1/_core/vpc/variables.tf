variable "vpc_cog_cidr" {
  default = "10.9.0.0/16"
}

variable "vpc_cog_public_subnet_cidrs" {
  default = ["10.9.8.0/24", "10.9.7.0/24", "10.9.6.0/24"]
  type = "list"
}

variable "vpc_cog_private_subnet_cidrs" {
  default = ["10.9.11.0/24", "10.9.10.0/24", "10.9.9.0/24"]
  type = "list"
}

variable "vpc_cog_zones" {
  default = [ "d", "c", "b" ]
  type = "list"
}
