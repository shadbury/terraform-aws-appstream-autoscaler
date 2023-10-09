resource "aws_sfn_state_machine" "appstream_autoscale_state_machine" {
  name     = "appstream_autoscaling_state_machine"
  role_arn = aws_iam_role.steps_execution_role.arn
  type     = "STANDARD"

  definition = <<EOF
{
  "Comment": "State machine for Appstream autoscaling",
  "StartAt": "Choice",
  "States": {
    "Choice": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.state",
          "StringEquals": "peak",
          "Next": "Disable_Off_Peak"
        },
        {
          "Variable": "$.state",
          "StringEquals": "off_peak",
          "Next": "Disable_Peak"
        }
      ]
    },
    "Disable_Off_Peak": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[1].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:disableAlarmActions",
      "Next": "Enable_Peak"
    },
    "Enable_Peak": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[0].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:enableAlarmActions",
      "End": true
    },
    "Disable_Peak": {
      "Type": "Task",
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[0].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:disableAlarmActions",
      "Next": "Enable_off_peak"
    },
    "Enable_off_peak": {
      "Type": "Task",
      "End": true,
      "Parameters": {
        "AlarmNames": [
          "${local.cloudwatch_alarms[1].alarm_name}"
        ]
      },
      "Resource": "arn:aws:states:::aws-sdk:cloudwatch:enableAlarmActions"
    }
  }
}
EOF
}