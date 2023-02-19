variable env {
    type = string
}

variable account {
    type = string
}

variable region {
    type = string
}

variable identity_store_id {
    type = string
}

variable subnet_id {
    type = string
    default = "fake-id"
}

variable "LogUri" {
  type = string
  default = "s3://aws-logs-251863357540-us-east-1//elasticmapreduce//"
}