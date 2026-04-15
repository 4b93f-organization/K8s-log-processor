variable "sqs_queue_url" {
  description = "SQS queue URL passed to worker and API"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "aws_endpoint_url" {
  description = "AWS endpoint URL (LocalStack or real AWS)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "worker_image" {
  description = "Docker image for worker"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the worker deployment"
  type        = string
}