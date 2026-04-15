output "url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.sqs_queue.url
}