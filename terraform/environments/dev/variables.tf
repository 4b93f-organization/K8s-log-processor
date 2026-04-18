variable "auth_token" {
    description = "Authentication token for LocalStack"
    type        = string
    sensitive   = true
}

variable "bucket_name" {
    description = "Name of the S3 bucket"
    type        = string
    default     = "log-processing"
}

variable "sqs_name" {
    description = "Name of the SQS queue"
    type        = string
    default     = "log-processing"
}

variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}
