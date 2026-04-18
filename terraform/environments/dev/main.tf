module "s3" {
    source = "../../modules/aws/s3"
    bucket_name = var.bucket_name
}

module "sqs" {
    source = "../../modules/aws/sqs"
    name = var.sqs_name
}