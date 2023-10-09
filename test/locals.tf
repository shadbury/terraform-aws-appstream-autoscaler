locals {

  env = {
    prod = {
        aws_profile       = "<aws profile>"
        region            = "<aws region>"


    }
  }

  workspace = local.env[terraform.workspace]
}