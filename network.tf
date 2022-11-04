# Get network id and router id 
data "openstack_networking_network_v2" "vpc_network" {
    name = var.vpc
}

data "openstack_networking_router_v2" "router" {
    name = var.vpc_router
}

data "openstack_networking_subnet_v2" "subnets" {
    for_each = var.subnet
    name = each.value
}

locals {
    vpc_network = data.openstack_networking_network_v2.vpc_network.id
    external = data.openstack_networking_subnet_v2.subnets["external"].id
    internal = data.openstack_networking_subnet_v2.subnets["internal"].id
    mirror = data.openstack_networking_subnet_v2.subnets["mirror"].id
}

# Create port

# Create port for LB instance
resource "openstack_networking_port_v2" "idslb_external" {
    name           = "idslb_external"
    network_id     = local.vpc_network
    admin_state_up = "true"
    port_security_enabled = "false"
    no_security_groups = "true"
    fixed_ip {
        subnet_id = local.external
        ip_address = var.idslb_external_interface_ip
    }
}

resource "openstack_networking_port_v2" "idslb_mirror" {
    name           = "idslb_mirror"
    network_id     = local.vpc_network
    admin_state_up = "true"
    port_security_enabled = "false"
    no_security_groups = "true"
    fixed_ip {
        subnet_id = local.mirror
        ip_address = var.idslb_mirror_interface_ip
    }
}

resource "openstack_networking_port_v2" "idslb_internal" {
    name           = "idslb_internal"
    network_id     = local.vpc_network
    admin_state_up = "true"
    port_security_enabled = "false"
    no_security_groups = "true"
    fixed_ip {
        subnet_id = local.internal
        ip_address = var.idslb_internal_interface_ip
    }
}

# Create port for LB instance
resource "openstack_networking_port_v2" "ids_external" {
    name           = "ids_external"
    network_id     = local.vpc_network
    port_security_enabled = "false"
    no_security_groups = "true"
    admin_state_up = "true"
    fixed_ip {
        subnet_id = local.external
    }
}

resource "openstack_networking_port_v2" "ids_mirror" {
    name           = "ids_mirror"
    network_id     = local.vpc_network
    port_security_enabled = "false"
    no_security_groups = "true"
    admin_state_up = "true"
    fixed_ip {
        subnet_id = local.mirror
        ip_address = var.ids_mirror_interface_ip
    }
}

# Create port for App instance
resource "openstack_networking_port_v2" "app_internal" {
    name           = "app_internal"
    network_id     = local.vpc_network
    admin_state_up = "true"
    fixed_ip {
        subnet_id = local.internal
    }
}

# Set Route for Internet GW
/* folllowing resources are not supported in NHN Cloud
resource "openstack_networking_router_route_v2" "igw_route" {
  router_id        = data.openstack_networking_router_v2.router.id
  destination_cidr = data.openstack_networking_subnet_v2.subnets["internal"].cidr
  next_hop         = openstack_compute_instance_v2.idslb.network.0.fixed_ip_v4
}

# Set Subnet Router 
resource "openstack_networking_subnet_route_v2" "internal_subnet_route" {
  subnet_id        = data.openstack_networking_subnet_v2.subnets["internal"].id
  destination_cidr = "0.0.0.0/0"
  next_hop         = openstack_compute_instance_v2.idslb.network.2.fixed_ip_v4
}
 */