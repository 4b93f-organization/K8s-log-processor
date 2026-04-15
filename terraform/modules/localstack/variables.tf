variable "name" {
    description = "Name of the localstack release"
    type = string
    default = "localstack"
}

variable "auth_token" {
    description = "Authentication token for the Helm repository (if required)"
    type = string
    sensitive = true
}