module "s3" {
    source = "../../modules/aws/s3"
    bucket_name = var.bucket_name
}

module "sqs" {
    source = "../../modules/aws/sqs"
    name = var.sqs_name
}

module "namespace" {
    source = "../../modules/k8s/namespace"
}

module "worker" {
    source = "../../modules/k8s/worker"
    namespace = module.namespace.name
    worker_image = var.worker_image
    sqs_queue_url = module.sqs.url
    aws_region = var.aws_region
    aws_endpoint_url = var.aws_endpoint_url
    s3_bucket = module.s3.bucket_name
}