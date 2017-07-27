variable "vpc_cog_cidr" {
  default = "10.8.0.0/16"
}

variable "vpc_cog_public_subnet_cidrs" {
  default = ["10.8.8.0/24", "10.8.7.0/24", "10.8.6.0/24"]
  type = "list"
}

variable "vpc_cog_private_subnet_cidrs" {
  default = ["10.8.11.0/24", "10.8.10.0/24", "10.8.9.0/24"]
  type = "list"
}

variable "vpc_cog_zones" {
  default = [ "c", "b", "a" ]
  type = "list"
}
