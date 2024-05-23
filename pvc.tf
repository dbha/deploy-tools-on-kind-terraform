# resource "kubernetes_persistent_volume_claim" "demo" {
#   metadata {
#     name = "demo-pvc"
#     namespace = kubernetes_namespace.demo.metadata[0].name
#   }

#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#   }
# }
