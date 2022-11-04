# parameters configured by user in terraform.tfvars file or enviroment
variable provider_user_name  {
    type = string
    sensitive = true
}

variable provider_tenant_id  {
    type = string
    sensitive = true
}

variable provider_password {
    type = string
    sensitive = true
}

variable "vpc" {
    type = string
}

variable "vpc_router" {
    type = string
}

variable "idslb_external_interface_ip" {
    type = string
}

variable "idslb_mirror_interface_ip" {
    type = string
}

variable "idslb_internal_interface_ip" {
    type = string
}

variable "ids_mirror_interface_ip" {
    type = string
}

# default config
variable provider_region {
    type = string
    default = "KR1"
}

variable provider_auth_url {
    type = string
    default = "https://api-identity.infrastructure.cloud.toast.com/v2.0"
}

variable "os_image" {
    type = string
    default = "Ubuntu Server 20.04.3 LTS (2021.12.21)"
}

variable "instance_type" {
    type = string
    default = "t2.c1m1"
}

variable "keypair" {
    type = string
}

variable "security_group" {
    type = string
    default = "default"
}

variable "subnet" {
    type = map(string)
    default = {
        external = "external"
        mirror = "mirror"
        internal = "internal"
    }
}

variable "public_network" {
    type = string
    default = "Public Network"
}

variable "tcp_mss" {
    type = string
    default = "1410"
    description = "To circumvente MTU issue related with VXLAN overhead, decrese TCP MSS value to tcp_mss"
}