resource "helm_release" "mariadb" {
  name      = "nextcloud-db"
  namespace = "nextcloud"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"

  set {
    name  = "auth.database"
    value = var.db_name
  }

  set {
    name  = "auth.username"
    value = var.db_username
  }

  set {
    name  = "auth.password"
    value = var.db_password
  }
}
