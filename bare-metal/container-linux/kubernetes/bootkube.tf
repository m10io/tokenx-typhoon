# Self-hosted Kubernetes assets (kubeconfig, manifests)
module "bootkube" {
  source = "git::https://github.com/poseidon/terraform-render-bootkube.git?ref=4b04125f956cd95635aa8af3946ea5f0cf0ee2eb"

  cluster_name                    = "${var.cluster_name}"
  api_servers                     = ["${var.k8s_domain_name}"]
  etcd_servers                    = ["${var.controller_domains}"]
  asset_dir                       = "${var.asset_dir}"
  networking                      = "${var.networking}"
  network_mtu                     = "${var.network_mtu}"
  network_ip_autodetection_method = "${var.network_ip_autodetection_method}"
  pod_cidr                        = "${var.pod_cidr}"
  service_cidr                    = "${var.service_cidr}"
  cluster_domain_suffix           = "${var.cluster_domain_suffix}"
}
