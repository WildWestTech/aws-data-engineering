variable "env" {
  type = string
}

variable "bucket_list" {
   type= list
   default= [
    "bronze",
    "silver",
    "gold",
    "glue",
    "emr-studio-workspace",
    "emr-studio-resources",
    "service-catalog",
    "logs",
    "mwaa"
    ]
}