module "appstream_autoscaler" {
    source = "../module"

    fleet_name          = local.workspace.fleet_name
    scale_out_off_peak  = local.workspace["scale_out_off_peak"]
    scale_out           = local.workspace["scale_out"]
    scale_in            = local.workspace["scale_in"]
    minimum_capacity    = local.workspace["minumum_capacity"]
    maximum_capacity    = local.workspace["maximum_capacity"]
}