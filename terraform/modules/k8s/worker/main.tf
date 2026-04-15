resource "kubernetes_deployment" "worker" {
  metadata {
    name = "worker-deployment"
    namespace = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "worker"
      }
    }
    template {
      metadata {
        labels = {
          app = "worker"
        }
      }
      spec {
        container {
          name  = "worker"
          image = var.worker_image

          env {
            name  = "SQS_QUEUE_URL"
            value = var.sqs_queue_url
          }
          env {
            name  = "AWS_REGION"
            value = var.aws_region
          }
          env {
            name  = "AWS_ENDPOINT_URL"
            value = var.aws_endpoint_url
          }
          env {
            name  = "S3_BUCKET"
            value = var.s3_bucket
          }
          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = "placeholder"
          }
          env {
            name  = "AWS_SECRET_ACCESS_KEY"
            value = "placeholder"
          }
          resources {
            requests = {
              cpu = "500m"
              memory = "256Mi"
            }
            limits = {
              cpu = "1"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}