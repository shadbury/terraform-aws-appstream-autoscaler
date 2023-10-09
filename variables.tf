variable scale_out {
    description = "scale out threshold"
    type        = object(
        {
            cron         = string
            threshold    = number
            increment_by = number
        }
    )
    
}

variable scale_out_off_peak {
    description = "scale out threshold for weekend"
    type        = object(
        {
            cron         = string
            threshold    = number
            increment_by = number
        }
    )
}

variable scale_in {
    description = "scale in threshold"
    type        = object(
        {
            threshold    = number
            decrement_by = number
        }
    )
}

variable fleet_name {
    description = "fleet name"
    type        = string
}

variable minimum_capacity {
    description = "minimum capacity"
    type        = number
}

variable maximum_capacity {
    description = "maximum capacity"
    type        = number
}

