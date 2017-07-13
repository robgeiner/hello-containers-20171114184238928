resource "aws_elasticsearch_domain" "logging" {
    domain_name = "${var.PROJECT}-${var.ENVIRONMENT}"
    elasticsearch_version = "${var.elasticsearch_version}"
    ebs_options {
      ebs_enabled = true
      volume_type = "${var.volume_type}"
      volume_size = "${var.volume_size}"
    }
    cluster_config {
      instance_type = "${var.instance_type}"
      instance_count = "${var.instance_count}"
      dedicated_master_enabled = true
      dedicated_master_type = "${var.dedicated_master_type}"
      dedicated_master_count = "${var.dedicated_master_count}"
      zone_awareness_enabled = true
    }

    snapshot_options {
        automated_snapshot_start_hour = 23
    }

    tags {
      Domain = "${var.PROJECT}"
      Billing = "${var.BILLING_CODE}"
    }

}
