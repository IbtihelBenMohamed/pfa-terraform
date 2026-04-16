data "openstack_networking_secgroup_v2" "sg_firewall" { name = "SG-FIREWALL" }
data "openstack_networking_secgroup_v2" "sg_web" { name = "SG-WEB" }
data "openstack_networking_secgroup_v2" "sg_db" { name = "SG-DB" }
data "openstack_networking_secgroup_v2" "sg_ids" { name = "SG-IPS" }
