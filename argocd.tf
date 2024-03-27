
# Install ArgoCD

resource "null_resource" "wait_for_ArgoCD" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nInstall ArgoCD by yaml \n"
      kubectl create ns ${var.argocd_namespace}
      kubectl apply -n ${var.argocd_namespace} \
        -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    EOF
  }

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.metallb,
  ]
}
