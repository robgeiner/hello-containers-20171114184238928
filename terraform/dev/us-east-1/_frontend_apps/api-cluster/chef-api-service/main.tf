module "target_group" {
  source = "git::ssh://git@github.com/TheWeatherCompany/twc-ecs-modules.git//terraform/target-group"
  name = "${var.ENVIRONMENT}-${data.terraform_remote_state.cluster.cluster_short_name}-${data.terraform_remote_state.service-registry.chef_api_name}"
  project = "${var.PROJECT}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  healthcheck_path = "${data.terraform_remote_state.service-registry.chef_api_healthcheck_path}"
  healthcheck_protocol = "${data.terraform_remote_state.service-registry.chef_api_healthcheck_protocol}"
}

resource "aws_alb_listener_rule" "https-global-rule" {
  listener_arn = "${data.terraform_remote_state.cluster.listener_public_arn}"
  priority = "${data.terraform_remote_state.service-registry.chef_api_global_priority}"
  action {
    type = "forward"
    target_group_arn = "${module.target_group.arn}"
  }
  condition {
    field = "host-header"
    values = ["${data.terraform_remote_state.service-registry.chef_api_global_hostname}"]
  }
}

resource "aws_alb_listener_rule" "https-region-rule" {
  listener_arn = "${data.terraform_remote_state.cluster.listener_public_arn}"
  priority = "${data.terraform_remote_state.service-registry.chef_api_region_priority}"
  action {
    type = "forward"
    target_group_arn = "${module.target_group.arn}"
  }
  condition {
    field = "host-header"
    values = ["${data.terraform_remote_state.service-registry.chef_api_region_hostname}"]
  }
}

data "template_file" "task_template" {
    template = "${file("./task-definition-template.json")}"
    vars {
      app_repository_url = "${data.terraform_remote_state.app-repository.repository_url}"
      app_name = "${data.terraform_remote_state.service-registry.chef_api_name}"
      app_version = "${var.app_version}"
      cpu = "${var.cpu}"
      background = "${var.background}"
      environment = "${var.ENVIRONMENT}"
      region = "${var.REGION}"
      log_level = "${var.log_level}"
      debug_options = "${var.debug_options}"
      memory = "${var.memory}"
      port = "${var.port}"
      project = "${var.PROJECT}"
      profiler = "${var.profiler}"
      bar_queue_arn = "${var.BAR_QUEUE_ARN}"
      bar_queue_name = "${var.BAR_QUEUE_NAME}"
      bar_read_access_key = "${var.BAR_READ_ACCESS_KEY}"
      bar_read_access_secret_key = "${var.BAR_READ_SECRET_KEY}"
      bar_read_user = "${var.BAR_READ_USER}"
      bar_write_access_key = "${var.BAR_WRITE_ACCESS_KEY}"
      bar_write_secret_key = "${var.BAR_WRITE_SECRET_KEY}"
      bar_write_user = "${var.BAR_WRITE_USER}"
      stream_access_key = "${var.BAR_STREAM_ACCESS_KEY}"
      stream_access_secret = "${var.BAR_STREAM_ACCESS_SECRET}"
      newrelic_app_name = "${data.terraform_remote_state.service-registry.chef_api_name}-${var.ENVIRONMENT}"
      newrelic_license_key = "${var.NEW_RELIC_LICENSE_KEY}"
      weather_api_key = "${var.WEATHER_API_KEY}"
      image_root = "${lookup(var.image_roots, var.ENVIRONMENT)}"
      campbells_api_root = "http://cogads-be-cb-${lookup(var.hostnames, var.ENVIRONMENT)}"
      campbells2017_api_root = "http://cogads-be-cb2-${lookup(var.hostnames, var.ENVIRONMENT)}"
      ccrock_api_root = "http://cogads-be-cc-${lookup(var.hostnames, var.ENVIRONMENT)}"
      hellmans_api_root = "http://cogads-be-hl-${lookup(var.hostnames, var.ENVIRONMENT)}"
      swanson_api_root = "http://cogads-be-sw-${lookup(var.hostnames, var.ENVIRONMENT)}"
      bonappnw_api_root = "http://cogads-be-ban-${lookup(var.hostnames, var.ENVIRONMENT)}"
    }
}

resource "aws_ecs_task_definition" "task_definition" {
    family = "${data.terraform_remote_state.service-registry.chef_api_name}-${var.ENVIRONMENT}"
    container_definitions = "${data.template_file.task_template.rendered}"
    volume {
      name = "tmp"
      host_path = "/tmp"
    }
}

resource "aws_ecs_service" "service" {
    name = "${data.terraform_remote_state.service-registry.chef_api_name}-${var.ENVIRONMENT}"
    cluster = "${data.terraform_remote_state.cluster.cluster_id}"
    task_definition = "${aws_ecs_task_definition.task_definition.arn}"
    iam_role = "${data.terraform_remote_state.iam.ecsServiceRole_arn}"
    desired_count = "${var.desired_count}"
    deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
    deployment_maximum_percent = "${var.deployment_maximum_percent}"

    load_balancer {
        target_group_arn = "${module.target_group.arn}"
        container_name = "${data.terraform_remote_state.service-registry.chef_api_name}"
        container_port = "${var.port}"
    }
    placement_strategy {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }
    placement_constraints {
      type = "distinctInstance"
    }
  #  lifecycle {
  #    ignore_changes = ["desired_count"]
  #  }
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
