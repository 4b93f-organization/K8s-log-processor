resource "helm_release" "localstack" {
    name = "${var.name}-release"
    repository = "https://localstack.github.io/helm-charts"
    chart = "localstack"
    namespace = "localstack"
    create_namespace = true
    set_sensitive = [
    {
      name  = "extraEnvVars[0].name"
      value = "LOCALSTACK_AUTH_TOKEN"
    },
    {
      name  = "extraEnvVars[0].value"
      value = var.auth_token
    }
  ]
}