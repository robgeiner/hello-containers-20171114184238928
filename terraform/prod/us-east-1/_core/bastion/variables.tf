variable "chef_version" {
   default = "12.13.37"
}

variable "additional_ips" {
   default = "71.0.127.137/32,52.2.245.178/32"  # rob geiner home and jenkins_sun
}  # dev/devops home static ips

variable "chef_run_list" {
   default = ["role[base-ads]"]
   type = "list"
}
