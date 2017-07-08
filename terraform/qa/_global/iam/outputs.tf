output "basic_role_name" {
  value = "${aws_iam_role.basic_role.name}"
}

output "basic_profile_name" {
  value = "${aws_iam_instance_profile.basic_profile.name}"
}

output "basic_role_arn" {
  value = "${aws_iam_role.basic_role.arn}"
}

output "varnish_role_name" {
  value = "${aws_iam_role.varnish_role.name}"
}

output "varnish_profile_name" {
  value = "${aws_iam_instance_profile.varnish_profile.name}"
}

output "varnish_role_arn" {
  value = "${aws_iam_role.varnish_role.arn}"
}
