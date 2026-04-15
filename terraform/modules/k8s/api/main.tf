resource "kubernetes_deployment" "worker" {
  metadata {
    name = "api-deployment"
    namespace = var.namespace
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "api"
      }
    }
    template {
      metadata {
        labels = {
          app = "api"
        }
      }
      spec {
        container {
          name  = "api"
          image = var.api_image

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

resource "kubernetes_service" "api" {
  metadata {
    name = "api-service"
    namespace = var.namespace
  }
  spec {
    type = "NodePort"
    selector = {
      app = "api"
    }
    port {
      port = 8000
      target_port = 8000
    }
  }
}