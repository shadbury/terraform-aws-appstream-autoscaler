locals {

  env = {
    prod = {
        aws_profile       = "<aws profile>"
        region            = "<aws region>"
        fleet_name        = "<fleet name>"
        minumum_capacity  = 1
        maximum_capacity  = 1

        scale_out_off_peak = {
            cron         = "0 18 ? * * *"
            threshold     = 5
            increment_by  = 5
        }

        scale_out = {
            cron         = "0 6 ? * MON-FRI *"
            threshold    = 7
            increment_by = 1
        }

        scale_in = {
            threshold    = 3
            decrement_by = -1
        }

    }
  }

  workspace = local.env[terraform.workspace]
}