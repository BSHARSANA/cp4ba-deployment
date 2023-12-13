data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }

  provisioner "local-exec" {
    command = "mkdir -p ${var.cluster_config_path}"
  }
}

data "ibm_container_cluster_config" "cluster_config" {
  depends_on        = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.resource_group.id
  config_dir        = var.cluster_config_path
}

module "install_cp4ba" {
  source = "../.."
  enable_cp4ba           = true
  enable_db2             = true
  ibmcloud_api_key       = var.ibmcloud_api_key
  region                 = var.region
  resource_group         = var.resource_group
  cluster_config_path    = data.ibm_container_cluster_config.cluster_config.config_file_path
  ingress_subdomain      = var.ingress_subdomain
  # ---- Platform ----
  cp4ba_project_name     = var.cp4ba_project_name
  entitled_registry_user_email = var.entitled_registry_user_email
  entitled_registry_key        = var.entitled_registry_key

  storage_class_rwo=var.storage_class_rwo
  storage_class=var.storage_class
  
}