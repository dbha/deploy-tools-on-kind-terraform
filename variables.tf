# variables.tf

variable "cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "kind-devops-tool"
}

variable "cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}

variable "ingress_nginx_helm_version" {
  type        = string
  description = "The Helm version for the nginx ingress controller."
  default     = "4.7.1"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "The nginx ingress namespace (it will be created if needed)."
  default     = "ingress-nginx"
}

variable "metallb_helm_version" {
  type        = string
  description = "The Helm version for the metallb LoadBalancer."
  default     = "0.14.3"
}

variable "metallb_namespace" {
  type        = string
  description = "The metallb namespace (it will be created if needed)."
  default     = "metallb-system"
}

variable "argocd_namespace" {
  type        = string
  description = "The argocd namespace (it will be created if needed)."
  default     = "argocd"
}

variable "jenkins_helm_version" {
  type        = string
  description = "The Helm version for the metallb LoadBalancer."
  default     = "5.1.4"
}

variable "jenkins_namespace" {
  type        = string
  description = "The metallb namespace (it will be created if needed)."
  default     = "jenkins"
}

variable "vault_helm_version" {
  type        = string
  description = "The Helm version for the vault."
  default     = "0.28.0"
}

variable "vault_namespace" {
  type        = string
  description = "The vault namespace (it will be created if needed)."
  default     = "vault"
}

variable "grafana_helm_version" {
  type        = string
  description = "The Helm version for the grafana."
  default     = "2.10.2"
}

variable "grafana_namespace" {
  type        = string
  description = "The monitoring namespace (it will be created if needed)."
  default     = "monitoring"
}


