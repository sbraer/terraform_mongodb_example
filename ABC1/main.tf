terraform { 
    required_providers { 
      kubernetes = { 
        source  = "hashicorp/kubernetes" 
        version = ">= 2.0.0" 
      } 
  } 
}

provider "kubernetes" { 
    config_path = "~/.kube/config" 
} 

resource "kubernetes_namespace" "test" { 
    metadata { 
        name = "test-abc" 
    } 
}

output "namespace-id" { 
  description = "Id per test-abc"  
  value = kubernetes_namespace.test.id
}

output "namespace-uid" { 
  description = "uid per test-abc"  
  value = kubernetes_namespace.test.metadata[0].uid
}
