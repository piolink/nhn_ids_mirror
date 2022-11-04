data "openstack_images_image_v2" "ubuntu_2004" {
	name = var.os_image
	most_recent = "true"
} 

data "openstack_compute_flavor_v2" "c1m1" {
	name = var.instance_type
}

locals {
	ubuntu_2004 = data.openstack_images_image_v2.ubuntu_2004.id
	c1m1 = data.openstack_compute_flavor_v2.c1m1.id
}

# IDSLB instance
resource "openstack_compute_instance_v2" "idslb" {
  name = "idslb"
  image_id = local.ubuntu_2004
  flavor_id = local.c1m1
  key_pair = var.keypair
  security_groups = [ var.security_group ]
  user_data = templatefile("init_script_idslb.tftpl", {
      IP_IDSLB = var.idslb_mirror_interface_ip
      IP_IDS = var.ids_mirror_interface_ip
      TCP_MSS = var.tcp_mss
  })
  network {
    port = openstack_networking_port_v2.idslb_external.id
  }
  network {
    port = openstack_networking_port_v2.idslb_mirror.id
  }
  network {
    port = openstack_networking_port_v2.idslb_internal.id
  }
  block_device {
    uuid = local.ubuntu_2004
    boot_index = 0
    volume_size = 20
    source_type = "image"
    destination_type = "volume"
    delete_on_termination = "true"
  }
}

resource "openstack_networking_floatingip_v2" "idslb_public_ip" {
  pool = var.public_network
}

resource "openstack_compute_floatingip_associate_v2" "idslb_public_ip" {
  floating_ip = openstack_networking_floatingip_v2.idslb_public_ip.address
  instance_id = openstack_compute_instance_v2.idslb.id
  fixed_ip    = openstack_compute_instance_v2.idslb.network.0.fixed_ip_v4
}

# IDS Instance 
resource "openstack_compute_instance_v2" "ids" {
  name = "ids"
  image_id = local.ubuntu_2004
  flavor_id = local.c1m1
  key_pair = var.keypair
  security_groups = [ var.security_group ]
  user_data = templatefile("init_script_ids.tftpl", {
      IP_IDSLB = var.idslb_mirror_interface_ip
      IP_IDS = var.ids_mirror_interface_ip
  })
  network {
    port = openstack_networking_port_v2.ids_external.id
  }
  network {
    port = openstack_networking_port_v2.ids_mirror.id
  }
  block_device {
    uuid = local.ubuntu_2004
    boot_index = 0
    volume_size = 20
    source_type = "image"
    destination_type = "volume"
    delete_on_termination = "true"
  }
}

resource "openstack_networking_floatingip_v2" "ids_public_ip" {
  pool = var.public_network
}

resource "openstack_compute_floatingip_associate_v2" "ids_public_ip" {
  floating_ip = openstack_networking_floatingip_v2.ids_public_ip.address
  instance_id = openstack_compute_instance_v2.ids.id
  fixed_ip    = openstack_compute_instance_v2.ids.network.0.fixed_ip_v4
}

# App Instance
resource "openstack_compute_instance_v2" "app" {
  name = "app"
  image_id = local.ubuntu_2004
  flavor_id = local.c1m1
  key_pair = var.keypair
  security_groups = [ var.security_group ]
  network {
    port = openstack_networking_port_v2.app_internal.id
  }
  block_device {
    uuid = local.ubuntu_2004
    boot_index = 0
    volume_size = 20
    source_type = "image"
    destination_type = "volume"
    delete_on_termination = "true"
  }
}

resource "openstack_networking_floatingip_v2" "app_public_ip" {
  pool = var.public_network
}

resource "openstack_compute_floatingip_associate_v2" "app_public_ip" {
  floating_ip = openstack_networking_floatingip_v2.app_public_ip.address
  instance_id = openstack_compute_instance_v2.app.id
  fixed_ip    = openstack_compute_instance_v2.app.network.0.fixed_ip_v4
}