provider "kind" {
}

# provider "kubernetes" {
#   host                   = "https://your-k8s-api-server:6443"
#   client_certificate     = file("/path/to/client-cert.pem")
#   client_key             = file("/path/to/client-key.pem")
#   cluster_ca_certificate = file("/path/to/ca-cert.pem")
# }

provider "kubernetes" {
  config_path = pathexpand(var.cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.cluster_config_path)
  }
}
