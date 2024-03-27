# Install jenkins chart 

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.jenkins_helm_version

  namespace        = var.jenkins_namespace
  create_namespace = true

  values = [file("jenkins_values.yaml")]

  depends_on = [
    helm_release.ingress_nginx,
    helm_release.metallb,
  ]
}