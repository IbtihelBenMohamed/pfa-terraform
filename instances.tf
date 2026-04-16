# VM-Firewall (4 interfaces)
resource "openstack_compute_instance_v2" "vm_firewall" {
  name            = "VM-Firewall"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.medium"
  key_pair        = "keypair-pfa"
  security_groups = [data.openstack_networking_secgroup_v2.sg_firewall.name]
  user_data       = file("scripts/firewall-init.sh")

  network { name = "external" }
  network { name = "NET-DMZ" }
  network { name = "NET-PRIVE" }
  network { name = "NET-MONITORING" }
}

# VM-Web
resource "openstack_compute_instance_v2" "vm_web" {
  name            = "VM-Web"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.small"
  key_pair        = "keypair-pfa"
  security_groups = [data.openstack_networking_secgroup_v2.sg_web.name]
  user_data       = file("scripts/web-init.sh")
  network { name = "NET-DMZ" }
}

# VM-DB
resource "openstack_compute_instance_v2" "vm_db" {
  name            = "VM-DB"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.small"
  key_pair        = "keypair-pfa"
  security_groups = [data.openstack_networking_secgroup_v2.sg_db.name]
  user_data       = file("scripts/db-init.sh")
  network { name = "NET-PRIVE" }
}

# VM-IPS
resource "openstack_compute_instance_v2" "vm_ips" {
  name            = "VM-IPS"
  image_name      = "ubuntu-22.04"
  flavor_name     = "m1.small"
  key_pair        = "keypair-pfa"
  security_groups = [data.openstack_networking_secgroup_v2.sg_ids.name]
  user_data       = file("scripts/ips-init.sh")
  network { name = "NET-MONITORING" }
}


