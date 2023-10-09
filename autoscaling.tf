locals {
    common_autoscaling_policy = {
        max_capacity = var.minimum_capacity
        min_capacity = var.maximum_capacity
        resource_id = "fleet/${var.fleet_name}"
        scalable_dimension = "appstream:fleet:DesiredCapacity"
        service_namespace = "appstream"
        policy_type        = "StepScaling"
        adjustment_type = "ChangeInCapacity"
        metric_aggregation_type = "Maximum"
    }

    autoscaling_up_policies = [

        {
            name = "appstream_scale_out"
            step_adjustment = {
                metric_interval = 0.0
                scaling_adjustment = var.scale_out.increment_by
            }
            cooldown = 360
        },
        {
            name = "appstream_scale_out_off_peak"
            step_adjustment = {
                metric_interval = 0.0
                scaling_adjustment = var.scale_out_off_peak.increment_by
            }
            cooldown = 360
        }
    ]

    autoscaling_down_policies = [
        {
            name = "appstream_scale_in"
            step_adjustment = {
                metric_interval = 0.0
                scaling_adjustment = var.scale_in.decrement_by
            }
            cooldown = 360
        }
    ]
}



resource "aws_appautoscaling_target" "appstream_target" {
  max_capacity       = local.common_autoscaling_policy.max_capacity
  min_capacity       = local.common_autoscaling_policy.min_capacity
  resource_id        = local.common_autoscaling_policy.resource_id
  scalable_dimension = local.common_autoscaling_policy.scalable_dimension
  service_namespace  = local.common_autoscaling_policy.service_namespace
}


resource "aws_appautoscaling_policy" "appstream_scaling_policy_up" {
    count = length(local.autoscaling_up_policies)
    name               = local.autoscaling_up_policies[count.index].name
    policy_type        = local.common_autoscaling_policy.policy_type
    resource_id        = local.common_autoscaling_policy.resource_id
    scalable_dimension = local.common_autoscaling_policy.scalable_dimension
    service_namespace  = local.common_autoscaling_policy.service_namespace
    step_scaling_policy_configuration {
        adjustment_type = local.common_autoscaling_policy.adjustment_type
        metric_aggregation_type = local.common_autoscaling_policy.metric_aggregation_type
        step_adjustment {
            metric_interval_upper_bound = local.autoscaling_up_policies[count.index].step_adjustment.metric_interval
            scaling_adjustment          = local.autoscaling_up_policies[count.index].step_adjustment.scaling_adjustment
        }
        cooldown = local.autoscaling_up_policies[count.index].cooldown
    }
    depends_on = [ aws_appautoscaling_target.appstream_target ]
}

resource "aws_appautoscaling_policy" "appstream_scaling_policy_down" {
    count = length(local.autoscaling_down_policies)
    name               = local.autoscaling_down_policies[count.index].name
    policy_type        = local.common_autoscaling_policy.policy_type
    resource_id        = local.common_autoscaling_policy.resource_id
    scalable_dimension = local.common_autoscaling_policy.scalable_dimension
    service_namespace  = local.common_autoscaling_policy.service_namespace
    step_scaling_policy_configuration {
        adjustment_type = local.common_autoscaling_policy.adjustment_type
        metric_aggregation_type = local.common_autoscaling_policy.metric_aggregation_type
        step_adjustment {
            metric_interval_lower_bound = local.autoscaling_down_policies[count.index].step_adjustment.metric_interval
            scaling_adjustment          = local.autoscaling_down_policies[count.index].step_adjustment.scaling_adjustment
        }
        cooldown = local.autoscaling_down_policies[count.index].cooldown
    }
    depends_on = [ aws_appautoscaling_target.appstream_target ]
}