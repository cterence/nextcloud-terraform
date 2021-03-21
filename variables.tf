#######################
# Kubernetes provider #
#######################

variable "kube_config_path" {
  type        = string
  description = "Path of your Kubernetes config file"
}

variable "kube_config_context" {
  type        = string
  description = "Name of your Kubernetes cluster context"
}

###############################
# Nextcloud Kubernetes config #
###############################

variable "app_host" {
  type        = string
  default     = "nextcloud.kube.local"
  description = "Hostname of your Nextcloud instance"
}

variable "app_name" {
  type    = string
  default = "nextcloud"
}

variable "namespace" {
  type    = string
  default = "nextcloud"
}

variable "pv_name" {
  type    = string
  default = "nextcloud-data"
}

###################
# Database config #
###################

variable "db_name" {
  type    = string
  default = "nextcloud"
}

variable "db_username" {
  type    = string
  default = "nextcloud"
}

variable "db_password" {
  type    = string
  default = "nextcloud"
}

variable "db_host" {
  type    = string
  default = "nextcloud-db-mariadb"
}

################
# Redis config #
################

variable "redis_host" {
  type    = string
  default = "redis"
}
