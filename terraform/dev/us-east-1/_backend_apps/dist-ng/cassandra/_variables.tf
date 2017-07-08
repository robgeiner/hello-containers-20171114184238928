#####################################################################
# Empty variables defined by terraform-runner.sh, don't modify these!
#####################################################################
variable "OWNER_NAME" {}
variable "REMOTE_STATE_BUCKET_NAME" {}
variable "REGION" {}
variable "ENVIRONMENT" {}
variable "CHEF_VALIDATION_CLIENT_NAME" {}
variable "CHEF_VALIDATION_KEY_PATH" {}
variable "CHEF_SERVER_URL" {}
variable "SUN_MANAGED_STATE_BUCKET" {}
variable "SUN_MANAGED_STATE_KEY" {}
variable "SUN_MANAGED_STATE_REGION" {}
variable "SSH_KEY_NAME" {}
variable "REMOTE_STATE_BUCKET_REGION" {}
#####################################################################

variable "name_prefix" { default = "cassandra" }
variable "cluster_short_name" { default = "dist-ng" }

variable "node_count" { default = "2" }
variable "seed_count" { default = "1" }

variable "ami_user" { default = "centos" }
variable "instance_type" { default = "t2.medium" }
variable "ebs_optimized" { default = "false" }

# It will add and mount additional EBS devices.
variable "data_device_gb" { default = "20" }
variable "commitlog_device_gb" { default = "8" }

variable "bastion_user" { default = "ops-user" }

variable "billing" { default = "SUN" }
variable "tags" {
  type = "map"
  default = {
    "Skip-Zabbix" = "True"
    "Owner" = "b2c"
    "Team" = "b2c"
  }
}

variable "chef_role" { default = "cassandra-dist-ng" }
variable "chef_version" { default = "12.20.3" }

variable "initial_run_list" {
  type = "list"
  default = [
    "role[cassandra-dist-ng]"
  ]
}
