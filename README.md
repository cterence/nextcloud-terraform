# Nextcloud with Terraform

Terraform layer for a Nextcloud deployment on a bare-metal Kubernetes cluster.

It's built around MetalLB to provide the LoadBalancer service type, MariaDB for the database, Redis for caching and the Nextcloud `stable-apache` image.

**! This is not for production use !**  

The data is stored directly on the Kubernetes node where the pod will be running. This layer needs configuration to access remote storage in order to persist your data.

The Terraform state is stored locally, which is fine for testing purposes, but not for production use.

## Note

This layer was built around the [kind](https://kind.sigs.k8s.io/) (Kubernetes IN Docker) Kubernetes cluster. You'll might want to change the MetalLB config map according to your external CIDR (following this [guide](https://kind.sigs.k8s.io/docs/user/loadbalancer/#setup-address-pool-used-by-loadbalancers)).

## Install

* Initialize the layer

```
terraform init
```

* Setup your Kubernetes provider (you need to provide the `kube_config_path` and `kube_config_context` variables, cf. `variables.tf`)

```
touch default.tfvars
nano default.tfvars
```

* Apply the layer

```
terraform apply --var-file $(terraform workspace show).tfvars
```

* Fetch the loadbalancer's `EXTERNAL-IP` address

```
kubectl get svc nextcloud -n nextcloud
```

* Add this line to your `/etc/hosts` file (assuming you're running this on a Linux machine)

```
<external-ip> nextcloud.kube.local
```

You should now be able to access your Nextcloud instance at the address : [http://nextcloud.kube.local](http://nextcloud.kube.local)