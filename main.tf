resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
    labels = {
      app = var.app_name
    }
  }
}

resource "kubernetes_persistent_volume" "nextcloud" {
  metadata {
    name = var.pv_name
  }

  spec {
    persistent_volume_reclaim_policy = "Recycle"
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = "/nextcloud"
      }
    }
    storage_class_name = "standard"
  }
}

resource "kubernetes_persistent_volume_claim" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "standard"

    volume_name = kubernetes_persistent_volume.nextcloud.metadata.0.name
  }
}

resource "kubernetes_deployment" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = var.namespace
    annotations = {
      app = kubernetes_namespace.nextcloud.metadata.0.labels.app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = kubernetes_namespace.nextcloud.metadata.0.labels.app
      }
    }

    template {
      metadata {
        labels = {
          app = kubernetes_namespace.nextcloud.metadata.0.labels.app
        }
      }

      spec {
        volume {
          name = var.pv_name

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nextcloud.metadata.0.name
          }
        }

        container {
          name  = "nextcloud"
          image = "nextcloud:stable-apache"

          port {
            name           = "apache-port"
            container_port = 80
          }

          volume_mount {
            name       = var.pv_name
            mount_path = "/var/www/html"
          }

          env {
            name  = "NEXTCLOUD_TRUSTED_DOMAINS"
            value = var.app_host
          }

          env {
            name  = "MYSQL_DATABASE"
            value = var.db_name
          }

          env {
            name  = "MYSQL_USER"
            value = var.db_username
          }

          env {
            name  = "MYSQL_PASSWORD"
            value = var.db_password
          }

          env {
            name  = "MYSQL_HOST"
            value = var.db_host
          }

          env {
            name  = "REDIS_HOST"
            value = var.redis_host
          }

          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes_service" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = var.namespace
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    selector = {
      app = kubernetes_namespace.nextcloud.metadata.0.labels.app
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = var.namespace
  }

  spec {
    rule {
      host = var.app_host

      http {
        path {
          backend {
            service_name = kubernetes_service.nextcloud.metadata.0.name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}
