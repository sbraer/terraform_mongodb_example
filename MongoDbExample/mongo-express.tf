resource "kubernetes_deployment" "mongoexpress" { 
  metadata { 
    name = "mongoexpress" 
    namespace = kubernetes_namespace.test.metadata.0.name
  } 

  spec { 
    replicas = 1 
    selector { 
      match_labels = { 
        app = "mongoexpress" 
      } 
    }
    template { 
      metadata { 
        labels = { 
          app = "mongoexpress" 
        } 
        annotations = { 
          custom_text = "Mongoexpress web application"
        } 
      } 
      spec {
        volume {
          name = "secretvolume"
          secret {
            secret_name = "credentials1"
          }
        } 
        container { 
          image = "mkucuk20/mongo-express" 
          name  = "mongoexpress" 
          resources {
            limits = {
              memory = "100Mi"
              #cpu = 
            }
          }
          env { 
            name= "ME_CONFIG_MONGODB_ADMINUSERNAME_FILE" 
            value="/etc/secretvolume/username" 
          } 
          env { 
            name= "ME_CONFIG_MONGODB_ADMINPASSWORD_FILE" 
            value = "/etc/secretvolume/mongodb-root-password"
          } 
          env { 
            name= "ME_CONFIG_MONGODB_SERVER" 
            value="mongodb-easy-0.mongodb-easy-headless,mongodb-easy-1.mongodb-easy-headless,mongodb-easy-2.mongodb-easy-headless" 
          }
          volume_mount {
            name = "secretvolume"
            read_only = true
            mount_path = "/etc/secretvolume"
          }
        } 
      } 
    } 
  } 
  depends_on = [helm_release.mongodb1, kubernetes_secret.credentials1]
} 

resource "kubernetes_service" "mongoexpress-service" {
  metadata {
    name = "mongoexpress-service"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = "mongoexpress"
    }

    port {
      port        = 80
      target_port = 8081
      node_port = var.mongodb-express-port
    }

    type ="NodePort"
  }
  depends_on = [kubernetes_deployment.mongoexpress]
}