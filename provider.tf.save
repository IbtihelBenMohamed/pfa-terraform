terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51"
    }
  }
}

provider "openstack" {
  auth_url    = "http://10.20.20.1:5000/v3"
  user_name   = "admin"
  password    = var.os_password
  tenant_name = "admin"
  region      = "microstack"
  insecure    = true
}
