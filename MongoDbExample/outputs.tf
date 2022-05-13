output "mongodb-password" {
  description = "MongoDb password"
  value       = random_password.password[0].result
  sensitive = true
}

output "mongodb-express-port" {
  description = "MongoDb express port"
  value       = kubernetes_service.mongoexpress-service.spec[0].port[0].node_port
}

output "testdb-port" {
  description = "Api rest port"
  value       = kubernetes_service.testdb-service.spec[0].port[0].node_port
}

output "namespace" {
  description = "Namespace used"
  value       = kubernetes_namespace.test.metadata.0.name
}
