
resource "aws_security_group" "redis-ingress" {
  name = "${var.PROJECT}-${var.ENVIRONMENT}-${var.cache_identifier}-ingress"
  description = "Security Group for ElastiCache ${var.ENVIRONMENT}-${var.cache_identifier} cluster"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name        = "${var.cache_identifier}"
    Project     = "${var.PROJECT}"
    Environment = "${var.ENVIRONMENT}"
  }
}

resource "aws_security_group_rule" "redis-ingress" {
  type = "ingress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
#  source_security_group_id = "${var.source_security_group}"
  security_group_id = "${aws_security_group.redis-ingress.id}"
}

module "redis-cache" {
  source = "git::ssh://git@github.com/TheWeatherCompany/tf-aws-redis-elasticache.git"
  vpc_id                     = "${data.terraform_remote_state.vpc.vpc_id}"
  cache_identifier           = "${var.PROJECT}-${var.ENVIRONMENT}-${var.cache_identifier}"
  automatic_failover_enabled = "${var.automatic_failover}"
  desired_clusters           = "${var.cluster_count}"
  instance_type              = "${var.instance_type}"
  engine_version             = "${var.engine_version}"
  parameter_group            = "${var.parameter_group}"
  subnet_ids                 = "${data.terraform_remote_state.vpc.private_subnet_ids}"
  security_group_ids         = "${aws_security_group.redis-ingress.id}"
  alarm_cpu_threshold        = "${var.alarm_cpu_threshold}"
  alarm_memory_threshold     = "${var.alarm_memory_threshold}"
#  alarm_actions              = ["${aws_sns_topic.global.arn}"]
  project                    = "${var.PROJECT}"
  environment                = "${var.ENVIRONMENT}"
}
