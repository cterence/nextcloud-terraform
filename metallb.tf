resource "kubernetes_namespace" "metallb_system" {
  metadata {
    name = "metallb-system"
    labels = {
      app = "metallb"
    }
  }
}

resource "helm_release" "metallb" {
  name      = "metallb"
  namespace = "metallb-system"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"

  set {
    name  = "existingConfigMap"
    value = kubernetes_config_map.metallb_config.metadata.0.name
  }
}

resource "kubernetes_config_map" "metallb_config" {
  metadata {
    namespace = kubernetes_namespace.metallb_system.metadata.0.name
    name      = "config"
  }

  data = {
    config = <<EOF
address-pools:
- name: default
  protocol: layer2
  addresses:
  - 172.18.255.200-172.18.255.250
    EOF
  }
}
