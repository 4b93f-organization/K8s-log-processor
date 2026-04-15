variable "auth_token" {
    description = "Authentication token for the Helm repository (if required)"
    type = string
    sensitive = true
}

variable "bucket_name" {
  description = "Name of the S3 Bucket for the SQS queue"
  type = string
  default     = "log-processing"
}

variable "sqs_name" {
  description = "Name of the SQS queue"
  type = string
  default     = "log-processing"

}

variable "worker_image" {
  description = "Docker image for the worker"
  type = string
  default = "ghcr.io/4b93f/k8s-prod-worker:latest"
}

variable "aws_region" {
  description = "AWS region for the SQS queue and S3 bucket"
  type = string
  default = "us-east-1"
}

variable "aws_endpoint_url" {
  description = "AWS endpoint URL"
  type = string
}