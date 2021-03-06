resource "helm_release" "mongodb1" {
  name  = "mongodb-easy"

    repository = "https://charts.bitnami.com/bitnami"
    chart      = "mongodb"
    version    = "12.0.0"

  set {
    name = "global.namespaceOverride"
    value = kubernetes_namespace.test.metadata.0.name
  }

  set {
    name  = "architecture"
    value = "replicaset"
  }

  set {
    name  = "auth.rootUser"
    value = var.mongodb_username
  }

  set {
    name = "auth.existingSecret"
    value = "credentials1"
  }

  set {
    name = "auth.existingSecret"
    value = "credentials1"
  }

  set {
    name = "image.tag"
    value = "4.4.13-debian-10-r51"
  }

  set {
    name = "persistence.enabled"
    value = false
  }

  set {
    name = "arbiter.enabled"
    value = false
  }

  set {
    name = "replicaCount"
    value = 3
  }

  depends_on = [kubernetes_secret.credentials1]
}