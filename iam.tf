resource "aws_iam_role" "steps_execution_role" {
  name = "appstream-scaling-stepfunction-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "event_trigger_role"{
  name = "appstream-scaling-event-trigger-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "autoscaling_policy" {
  name        = "appstream-custom-autoscaling-policy"
  path        = "/"
  description = "Policy to manage Appstream Autoscaling"

  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "cloudwatch:DisableAlarmActions",
            "cloudwatch:EnableAlarmActions"
          ],
          "Effect": "Allow",
          "Resource": [
              aws_cloudwatch_metric_alarm.scaling_alarm[0].arn, 
              aws_cloudwatch_metric_alarm.scaling_alarm[1].arn, 
              aws_cloudwatch_metric_alarm.scaling_alarm[2].arn
            ]
        }
    ],
      "Version": "2012-10-17"
    }
  )
}

resource "aws_iam_policy" "event_trigger_policy" {
  name        = "appstream-custom-event-trigger-policy"
  path        = "/"
  description = "Policy to trigger step function"
  policy = jsonencode(
    {
      "Statement": [
        {
          "Action": [
            "states:StartExecution"
          ],
          "Effect": "Allow",
          "Resource": [
            aws_sfn_state_machine.appstream_autoscale_state_machine.arn
          ]
        }
    ],
      "Version": "2012-10-17"
    }
  )

}

resource "aws_iam_role_policy_attachment" "autoscaling_states_policy_attachment" {
  role       = aws_iam_role.steps_execution_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}

resource "aws_iam_role_policy_attachment" "autoscaling_events_policy_attachment" {
  role       = aws_iam_role.event_trigger_role.name
  policy_arn = aws_iam_policy.event_trigger_policy.arn
}