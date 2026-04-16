output "IP_FIREWALL" { value = openstack_compute_instance_v2.vm_firewall.access_ip_v4 }
output "IP_WEB" { value = openstack_compute_instance_v2.vm_web.access_ip_v4 }
output "IP_DB" { value = openstack_compute_instance_v2.vm_db.access_ip_v4 }
output "IP_IPS" { value = openstack_compute_instance_v2.vm_ips.access_ip_v4 }
