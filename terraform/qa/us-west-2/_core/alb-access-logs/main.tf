#####  log bucket

variable "alb_logs_bucket_retention_days" {
  default = "7"
}

data "template_file" "s3_alb_logs_policy" {
  template = "${file("./policies/s3_alb_logs_policy.json.template")}"
  vars {
    project = "${var.PROJECT_BUCKET_PREFIX}"
    env = "${var.ENVIRONMENT}"
    region = "${var.REGION}"
    suffix = "${var.bucket_suffix}"
    account_id = "${var.AWS_ACCOUNT_ID}"
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-${var.REGION}-${var.bucket_suffix}"
  acl = "private"
  policy = "${data.template_file.s3_alb_logs_policy.rendered}"

  lifecycle_rule {
    id = "public"
    enabled = true
    prefix = "public"
    expiration {
      days = "${var.alb_logs_bucket_retention_days}"
    }
  }

  lifecycle_rule {
    id = "private"
    enabled = true
    prefix = "private"
    expiration {
      days = "${var.alb_logs_bucket_retention_days}"
    }
  }
}
