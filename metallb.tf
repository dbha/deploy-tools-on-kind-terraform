# Install metallb chart 

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = var.metallb_helm_version

  namespace        = var.metallb_namespace
  create_namespace = true

  values = [file("metallb_values.yaml")]

  depends_on = [kind_cluster.default]
}

resource "null_resource" "wait_for_metallb" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nUpdate IPPool \n"
      kubectl apply -n ${helm_release.metallb.namespace} \
        -f metallb_ipaddress_pool.yaml
    EOF
  }

  depends_on = [
    helm_release.metallb
  ]
}