############### Shared Access Policy ####################
#### S3 read of shared buckets and setting EC2 tags #####
resource "aws_iam_policy" "shared_access" {
  name = "${var.OWNER_NAME}-shared-access"
  policy = "${file("./policies/shared_access_policy.json")}"
}

resource "aws_iam_policy_attachment" "shared_access" {
  name = "${var.OWNER_NAME}-shared-access-attachment"
  policy_arn = "${aws_iam_policy.shared_access.arn}"
  roles = [
    "${aws_iam_role.basic_role.name}",
    "${aws_iam_role.varnish_role.name}"
  ]
}

############# Generic Instance Role role ################
resource "aws_iam_role" "basic_role" {
  name = "${var.OWNER_NAME}-basic"
  assume_role_policy = "${file("./policies/default-assume.json")}"
}

resource "aws_iam_instance_profile" "basic_profile" {
  name = "${var.OWNER_NAME}-basic"
  role = "${aws_iam_role.basic_role.name}"
}

############# Varnish Instance Role role ################
resource "aws_iam_role" "varnish_role" {
  name = "${var.OWNER_NAME}-varnish"
  assume_role_policy = "${file("./policies/default-assume.json")}"
}

resource "aws_iam_instance_profile" "varnish_profile" {
  name = "${var.OWNER_NAME}-varnish"
  role = "${aws_iam_role.varnish_role.name}"
}

resource "aws_iam_role_policy" "varnish_elb_policy" {
    name = "${var.OWNER_NAME}-varnish_elb_policy"
    policy = "${file("./policies/varnish-elb-policy.json")}"
    role = "${aws_iam_role.varnish_role.id}"
}
