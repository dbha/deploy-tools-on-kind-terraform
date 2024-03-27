
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_helm_version

  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  values = [file("nginx_ingress_values.yaml")]

  depends_on = [
    kind_cluster.default,
    helm_release.metallb,
  ]
}

# A null_resource is a resource that does not perform any specific creation, modification, or destruction operations, in effect doing nothing.
# However, It can be used to perform secondary tasks or control the creation order of other resources, 
# such as through provisioners or setting dependencies with other resources (depends_on).
resource "null_resource" "wait_for_ingress_nginx" {
  triggers = {
    key = uuid()
  }

  # local-exec or remote-exec
  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the nginx ingress controller...\n"
      kubectl wait --namespace ${helm_release.ingress_nginx.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
    EOF
  }

  depends_on = [
    helm_release.ingress_nginx
  ]
}