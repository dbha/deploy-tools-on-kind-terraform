resource "kubernetes_deployment" "demo" {
  metadata {
    name = "demo-deployment"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo"
        }
      }

      spec {
        container {
          image = "dbha/nginxdemos:plain-text"
          name  = "demo"

          volume_mount {
            mount_path = "/etc/config"
            name       = "config"
          }

          volume_mount {
            mount_path = "/etc/secret"
            name       = "secret"
            read_only  = true
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.demo.metadata[0].name
          }
        }

        volume {
          name = "secret"
          secret {
            secret_name = kubernetes_secret.demo.metadata[0].name
          }
        }
      }
    }
  }
}

