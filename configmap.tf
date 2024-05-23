resource "kubernetes_config_map" "demo" {
  metadata {
    name = "demo-config"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    "config.json" = jsonencode({
      "key" = "value"
    })
  }
}