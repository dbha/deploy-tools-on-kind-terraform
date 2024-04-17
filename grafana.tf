# Install grafana chart 

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = var.grafana_helm_version

  namespace        = var.grafana_namespace
  create_namespace = true

  # values = [file("loki-config.yaml")]
  values = [file("my-loki-values.yaml")]

  depends_on = [kind_cluster.default]
}

resource "null_resource" "wait_for_grafana" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nCreate NodePort Service \n"
      kubectl apply -n ${helm_release.grafana.namespace} \
        -f grafana-svc.yaml

      USER=$(kubectl get secret grafana -n monitoring -o yaml -o jsonpath='{.data.admin-user}' | base64 -d)
      PASSWORD=$(kubectl get secret grafana -n monitoring -o yaml -o jsonpath='{.data.admin-password}' | base64 -d)
      echo "grafana user: $USER"
      echo "grafana passwd: $PASSWORD"
      
    EOF
  }

  depends_on = [
    helm_release.metallb
  ]
}