resource "kind_cluster" "default" {
  name            = var.cluster_name
  kubeconfig_path = pathexpand(var.cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 8080
        host_port      = 8080
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 30000
        host_port      = 30000
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 30092
        host_port      = 30092
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 31321
        host_port      = 31321
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 31300
        host_port      = 31300
        listen_address  = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 31400
        host_port      = 31400
        listen_address  = "0.0.0.0"
      }
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
    # node {
    #   role = "worker"
    # }
    # containerd_config_patches = [
    #   <<-TOML
    #   [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5000"]
    #     endpoint = ["http://kind-registry:5000"]
    #   TOML
    # ]
  }
}