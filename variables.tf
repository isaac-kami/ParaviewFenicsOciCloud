
variable "tenancy"{
  default = ""
}

variable "user" {
  default = ""
}

variable "private_key" {
  default = "/root/.oci/oci_api_key.pem"
}

variable "fingerprint" {
  default = ""
}

variable "region" {
  default = ""
}

### Tenancy OCID 

variable "compartment_ocid" {
  default = ""
}

#for vcn block

variable "cidrblockz" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

#for subnet internet gateway

variable "cidrsubnet_internet" {
  default = "10.0.1.0/24"
}

# for subnet nat gateway

variable "cidrsubnet_nat" {
  default = "10.0.2.0/24"
}

# for ingress


variable "cidr_ingress" {
  default = "10.0.0.0/16"
}

# for security list bastion

variable "port_bastion" {
 default = 22
}

## for nat

# for shape paraway

variable "instance_shape_par" {
 default = "VM.Standard.E2.2"
}

# for security list bastion

variable "instance_name_fenics_nat" {
  default = "Fenics instance"
}

variable "instance_name_paraview_nat" {
  default = "Paraview instance"
}

variable "port_nat" {
 default = [22,11111]
}


## for bastion instance


# Ubuntu 20.04 image
# as per link, choose the corresponding Ubuntu 20.04 image to your region
# https://docs.oracle.com/en-us/iaas/images/image/cb6a4ca4-47e9-40fa-bdb1-8ee41636c8a7/

variable "instance_image" {
  default =   ""
}

variable "instance_name" {
  default = "BastionInstance"
}

variable "instance_shape" {
  default = "VM.Standard.E2.1"
}

## availability domain 
## example: "Aodz:EU-FRANKFURT-1-AD-1"

variable "available_dom" {
  default = ""
}

variable "private_key_path" {
  default = "/root/.ssh/id_rsa"
}

#
## for bucket
variable  "name_bucket"{
  default = "examplebucket"
} 

variable "bucket_namespace" {
  default = "" ## add here your namespace
}
