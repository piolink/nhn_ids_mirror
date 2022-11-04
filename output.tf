# Print result of deployment

output "idslb_public_ip" {
    value = openstack_networking_floatingip_v2.idslb_public_ip.address
}

output "ids_public_ip" {
    value = openstack_networking_floatingip_v2.ids_public_ip.address
}

output "app_public_ip" {
    value = openstack_networking_floatingip_v2.app_public_ip.address
}

output "idslb_mirror_interface_ip" {
    value = openstack_compute_instance_v2.idslb.network.1.fixed_ip_v4
}

output "ids_mirror_interface_ip" {
    value = openstack_compute_instance_v2.ids.network.1.fixed_ip_v4
}

