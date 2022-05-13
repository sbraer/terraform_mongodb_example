terraform { 
  required_providers { 
    kubernetes = { 
      source  = "hashicorp/kubernetes" 
      version = ">= 2.0.0" 
    } 
    random = { 
      source = "hashicorp/random" 
      version = ">= 3.0.0" 
    } 
  }
}

provider "kubernetes" { 
    config_path = "~/.kube/config" 
} 

resource "random_password" "mypassword" { 
  count = 1
  length = 16 
  special = true 
} 

resource "kubernetes_namespace" "test" { 
  metadata { 
    name = "test-abc-2" 
    annotations = { 
      custom_text = "Stringa random: ${random_password.mypassword.0.result}"
    } 
  }
  depends_on = [random_password.mypassword]
}

output "namespace-id" { 
  description = "Id per test-abc"  
  value = kubernetes_namespace.test.id
}

output "namespace-uid" { 
  description = "uid per test-abc"  
  value = kubernetes_namespace.test.metadata[0].uid
}

output "password" { 
  description = "password"  
  value = kubernetes_namespace.test.metadata[0].annotations.custom_text
  sensitive = true
}
