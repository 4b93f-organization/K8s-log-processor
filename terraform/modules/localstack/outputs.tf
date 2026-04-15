output "name" {
  value = helm_release.localstack.name
}

output "url" {
  value = "http://${helm_release.localstack.name}.${helm_release.localstack.namespace}.svc.cluster.local:4566"
}