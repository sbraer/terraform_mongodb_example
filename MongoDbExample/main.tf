resource "kubernetes_namespace" "test" { 
  metadata { 
    name = var.namespace_name
  } 
}

resource "random_password" "password" { 
  count = 1 
  length = 32
  special = false
} 

resource "kubernetes_secret" "credentials1" {
  metadata {
    name = "credentials1"
    namespace = kubernetes_namespace.test.metadata.0.name
  }

  data = {
    "username" = var.mongodb_username
    "mongodb-password" = random_password.password.0.result
    "mongodb-root-password" = random_password.password.0.result
    "mongodb-replica-set-key" = "ba436283462dcaada36367"
  }

  type = "Opaque"
}