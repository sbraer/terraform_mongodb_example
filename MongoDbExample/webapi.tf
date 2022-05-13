resource "kubernetes_deployment" "testdb" { 
  metadata { 
    name = "testdb"
    namespace = kubernetes_namespace.test.metadata.0.name
  } 

  spec { 
    replicas = 1 
    selector { 
      match_labels = { 
        app = "testdb" 
      } 
    } 
    template { 
      metadata { 
        labels = { 
          app = "testdb" 
        } 
        annotations = { 
          custom_test = "Wep application rest to test MongoDb"
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
          image = "sbraer/mongodbtest:v1" 
          name  = "testdb"
          port {
            protocol = "TCP"
            container_port = 5000
          } 
          resources {
            limits = {
              memory = "100Mi"
              #cpu = 
            }
          }
          env { 
            name= "MONGODB_SERVER_USERNAME_FILE" 
            value = "/etc/secretvolume/username"
          } 
          env { 
            name= "MONGODB_SERVER_PASSWORD_FILE" 
            value = "/etc/secretvolume/mongodb-root-password"
          } 
          env { 
            name= "MONGODB_SERVER_LIST" 
            value="mongodb-easy-0.mongodb-easy-headless,mongodb-easy-1.mongodb-easy-headless,mongodb-easy-2.mongodb-easy-headless" 
          } 
          env { 
            name= "MONGODB_REPLICA_SET" 
            value="rs0" 
          } 
          env { 
            name= "MONGODB_DATABASE_NAME" 
            value="MyDatabase" 
          } 
          env { 
            name= "MONGODB_BOOKS_COLLECTION_NAME" 
            value="MyTest" 
          } 
          env { 
            name= "TMPDIR" 
            value="/tmp" 
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

resource "kubernetes_service" "testdb-service" {
  metadata {
    name = "testdb-service"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = "testdb"
    }

    port {
      port        = 80
      target_port = 5000
      node_port = var.testdb-port
    }

    type = "NodePort"
  }
  depends_on = [kubernetes_deployment.testdb]
}