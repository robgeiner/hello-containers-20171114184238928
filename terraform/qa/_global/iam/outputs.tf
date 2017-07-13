output "baseInstanceRole_name" {
  value = "${module.iam.baseInstanceRole_name}"
}

output "baseInstanceProfile_name" {
  value = "${module.iam.baseInstanceProfile_name}"
}

output "ecsServiceRole_arn" {
  value = "${module.iam.ecsServiceRole_arn}"
}

output "ecsApplAutoscalingRole_arn" {
  value = "${module.iam.ecsApplAutoscalingRole_arn}"
}
