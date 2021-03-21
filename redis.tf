resource "kubernetes_stateful_set" "redis" {
  metadata {
    name      = "redis"
    namespace = "nextcloud"
  }
  spec {
    service_name = "redis"
    replicas     = 1
    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          name  = "master"
          image = "redis"

          env {
            name  = "MASTER"
            value = "true"
          }

          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name      = "redis"
    namespace = "nextcloud"
  }

  spec {
    port {
      port        = 6379
      target_port = 6379
    }

    selector = {
      app = "redis"
    }
  }
}
