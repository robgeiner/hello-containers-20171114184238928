data "template_file" "task_template" {
    template = "${file("./task-definition-template.json")}"
    vars {
        app_repository_url = "${data.terraform_remote_state.repository.repository_url}"
        app_name = "${data.terraform_remote_state.service-registry.default_name}"
        app_version = "${var.version}"
        cpu = "${var.cpu}"
        background = "${var.background}"
        environment = "${var.ENVIRONMENT}"
        log_level = "${var.log_level}"
        memory = "${var.memory}"
        port = "${var.port}"
        project = "${var.PROJECT}"
        profiler = "${var.profiler}"
    }
}

resource "aws_ecs_task_definition" "task_definition" {
    family = "${data.terraform_remote_state.service-registry.default_name}-${var.ENVIRONMENT}"
    container_definitions = "${data.template_file.task_template.rendered}"
    volume {
      name = "creatives"
      host_path = "/opt/creatives/dist"
    }
    volume {
      name = "tmp"
      host_path = "/tmp"
    }
}

resource "aws_ecs_service" "service" {
    name = "${data.terraform_remote_state.service-registry.default_name}-${var.ENVIRONMENT}"
    cluster = "${data.terraform_remote_state.cluster.cluster_id}"
    task_definition = "${aws_ecs_task_definition.task_definition.arn}"
    iam_role = "${data.terraform_remote_state.iam.ecsServiceRole_arn}"
    desired_count = "${var.desired_count}"
    deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"


    load_balancer {
        target_group_arn = "${data.terraform_remote_state.cluster.tg_default_arn}"
        container_name = "${data.terraform_remote_state.service-registry.default_name}"
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
