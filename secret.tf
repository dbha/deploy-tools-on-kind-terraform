resource "kubernetes_secret" "demo" {
  metadata {
    name = "demo-secret"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    "password" = base64encode("supersecret")
  }
}
