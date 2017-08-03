module "target_group" {
  source = "git::ssh://git@github.com/TheWeatherCompany/twc-ecs-modules.git//terraform/target-group"
  name = "${var.ENVIRONMENT}-${data.terraform_remote_state.cluster.cluster_short_name}-${data.terraform_remote_state.service-registry.verizon_name}"
  project = "${var.PROJECT}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  healthcheck_path = "${data.terraform_remote_state.service-registry.verizon_healthcheck_path}"
  healthcheck_protocol = "${data.terraform_remote_state.service-registry.verizon_healthcheck_protocol}"
}

resource "aws_alb_listener_rule" "verizon" {
  listener_arn = "${data.terraform_remote_state.cluster.listener_public_arn}"
  priority     = "${data.terraform_remote_state.service-registry.verizon_priority}"
  action {
    type             = "forward"
    target_group_arn = "${module.target_group.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["${data.terraform_remote_state.service-registry.verizon_path}${data.terraform_remote_state.service-registry.verizon_api_key}*"]
  }
}

data "template_file" "task_template" {
    template = "${file("./task-definition-template.json")}"
    vars {
        app_repository_url = "${data.terraform_remote_state.repository.repository_url}"
        app_name = "${data.terraform_remote_state.service-registry.verizon_name}"
        app_version = "${var.version}"
        cpu = "${var.cpu}"
        background = "${var.background}"
        environment = "${var.ENVIRONMENT}"
        log_level = "${var.log_level}"
        debug_options = "${var.debug_options}"
        memory = "${var.memory}"
        port = "${var.port}"
        project = "${var.PROJECT}"
        profiler = "${var.profiler}"
        storage = "${var.storage}"
        redis_host = "${data.terraform_remote_state.ec-redis.endpoint}"
        redis_port = "${data.terraform_remote_state.ec-redis.port}"
        api_key = "${data.terraform_remote_state.service-registry.verizon_api_key}"
        twitter_consumer_key =  "${var.TWITTER_CONSUMER_KEY}"
        twitter_consumer_secret = "${var.TWITTER_CONSUMER_SECRET}"
        twitter_callback_url = "https://ui.${data.terraform_remote_state.route53.domain}${data.terraform_remote_state.service-registry.verizon_path}${data.terraform_remote_state.service-registry.verizon_api_key}/auth/twitter/callback"
    }
}

resource "aws_ecs_task_definition" "task_definition" {
    family = "${data.terraform_remote_state.service-registry.verizon_name}-${var.ENVIRONMENT}"
    container_definitions = "${data.template_file.task_template.rendered}"
    volume {
      name = "tmp"
      host_path = "/tmp"
    }
}

resource "aws_ecs_service" "service" {
    name = "${data.terraform_remote_state.service-registry.verizon_name}-${var.ENVIRONMENT}"
    cluster = "${data.terraform_remote_state.cluster.cluster_id}"
    task_definition = "${aws_ecs_task_definition.task_definition.arn}"
    iam_role = "${data.terraform_remote_state.iam.ecsServiceRole_arn}"
    desired_count = "${var.desired_count}"
    deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

    load_balancer {
        target_group_arn = "${module.target_group.arn}"
        container_name = "${data.terraform_remote_state.service-registry.verizon_name}"
        container_port = "${var.port}"
    }
    placement_strategy {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }
    placement_constraints {
      type = "distinctInstance"
    }
}

######## AutoScaling #######

resource "aws_appautoscaling_target" "service" {
  service_namespace = "ecs"
  resource_id = "service/${data.terraform_remote_state.cluster.cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn = "${data.terraform_remote_state.iam.ecsApplAutoscalingRole_arn}"
  min_capacity = "${var.asg_min}"
  max_capacity = "${var.asg_max}"
}

resource "aws_appautoscaling_policy" "up" {
  name = "${aws_ecs_service.service.name}-scale-up"
  service_namespace = "ecs"
  resource_id = "service/${data.terraform_remote_state.cluster.cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Maximum"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = 1
  }

  depends_on = ["aws_appautoscaling_target.service"]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name = "${aws_ecs_service.service.name}-CPU-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Maximum"
  threshold = "85"

  dimensions {
    ClusterName = "${data.terraform_remote_state.cluster.cluster_name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
}

resource "aws_appautoscaling_policy" "down" {
  name = "${aws_ecs_service.service.name}-scale-down"
  service_namespace = "ecs"
  resource_id = "service/${data.terraform_remote_state.cluster.cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Maximum"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = -1
  }

  depends_on = ["aws_appautoscaling_target.service"]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name = "${aws_ecs_service.service.name}-CPU-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions {
    ClusterName = "${data.terraform_remote_state.cluster.cluster_name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.down.arn}"]
}
