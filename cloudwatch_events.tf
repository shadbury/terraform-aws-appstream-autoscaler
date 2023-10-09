locals {
    event_rules = [
        {
            name        = "appstream_scale_out_off_peak"
            description = "Scale up AppStream fleet when available capacity is below ${var.scale_out_off_peak.threshold}."
            cron        = var.scale_out_off_peak.cron
            input       = <<JSON
            {
                "state": "off_peak"
            }
            JSON
        },
        {
            name        = "appstream_scale_out"
            description = "Scale up AppStream fleet when available capacity is below ${var.scale_out.threshold}."
            cron        = var.scale_out.cron
            input       = <<JSON
            {
                "state": "peak"
            }
            JSON
        }
    ]
}


resource "aws_cloudwatch_event_rule" "event_rules" {
  count       = length(local.event_rules)
  name        = local.event_rules[count.index].name
  description = local.event_rules[count.index].description
  schedule_expression = "cron(${local.event_rules[count.index].cron})"
}

resource "aws_cloudwatch_event_target" "targets" {
    count     = length(aws_cloudwatch_event_rule.event_rules)
    target_id = "target"
    role_arn  = aws_iam_role.event_trigger_role.arn
    arn       = aws_sfn_state_machine.appstream_autoscale_state_machine.arn
    rule      = aws_cloudwatch_event_rule.event_rules[count.index].name
    input     = local.event_rules[count.index].input
}