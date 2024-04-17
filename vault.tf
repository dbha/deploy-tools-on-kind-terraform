# Install vault chart 

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.vault_helm_version

  namespace        = var.vault_namespace
  create_namespace = true

  values = [file("vault_values.yaml")]

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.metallb,
  ]
}

resource "null_resource" "wait_for_vault" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nChange Status INITIALIZE & SEALED \n"
      ./initialize-vault.sh
    EOF
  }
  depends_on = [
    helm_release.vault,
  ]  
}