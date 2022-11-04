terraform {
required_version = ">= 1.0.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.42.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.provider_user_name
  tenant_id   = var.provider_tenant_id
  password    = var.provider_password
  auth_url    = var.provider_auth_url
  region      = var.provider_region
}
