# Appstream_custom_autoscaler

This repository contains Terraform code to deploy an autoscaling infrastructure for AWS AppStream fleets. The infrastructure includes AWS AppAutoScaling policies, CloudWatch alarms, AWS CloudWatch Event Rules, AWS Identity and Access Management (IAM) roles, and an AWS Step Functions state machine.


# Configuration
## Variables

- scale_out: Configuration for scaling out during peak hours.
    - cron: Cron expression for when to scale out.
    - threshold: Threshold for scaling out.
    - increment_by: Number of instances to add when scaling out.

- scale_out_off_peak: Configuration for scaling out during off-peak hours (e.g., weekends).
    - cron: Cron expression for when to scale out during off-peak hours.
    - threshold: Threshold for scaling out during off-peak hours.
    - increment_by: Number of instances to add when scaling out during off-peak hours.
    
- scale_in: Configuration for scaling in.
    - threshold: Threshold for scaling in.
    - decrement_by: Number of instances to remove when scaling in.

- fleet_name: Name of the AppStream fleet to scale.

- minimum_capacity: Minimum capacity for the AppStream fleet.

- maximum_capacity: Maximum capacity for the AppStream fleet.

# Terraform Resources

- aws_appautoscaling_target: Defines the target for AWS AppAutoScaling.

- aws_appautoscaling_policy: Configures scaling policies for the AppStream fleet.

- aws_cloudwatch_metric_alarm: Sets up CloudWatch alarms for scaling actions.

- aws_cloudwatch_event_rule: Defines CloudWatch Event Rules for triggering scaling actions based on cron expressions.

- aws_cloudwatch_event_target: Specifies the targets for CloudWatch Event Rules, triggering the Step Functions state machine.

- aws_iam_role: IAM roles for AWS services, including the Step Functions state machine and CloudWatch Events.

- aws_iam_policy: IAM policies to allow/disable CloudWatch alarm actions and trigger Step Functions executions.

- aws_iam_role_policy_attachment: Attach IAM policies to roles.

- aws_sfn_state_machine: Defines the AWS Step Functions state machine for managing scaling actions.


# Usage.
Once the infrastructure is deployed, it will automatically scale the AppStream fleet based on the configured CloudWatch alarms and cron expressions. Make sure to monitor the scaling activities in the AWS Management Console and adjust the thresholds as needed.


# Author
Joel Hutson

Feel free to reach out with any questions or issues related to this repository.