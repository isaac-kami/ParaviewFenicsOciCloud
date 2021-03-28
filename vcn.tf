resource "oci_core_virtual_network" "ExampleVCN" {
  cidr_blocks = var.cidrblockz
  compartment_id = oci_identity_compartment.ExampleCompartment.id
  display_name = "ExampleVCN"

  # for dns
 
  dns_label = "ExampleVCN"
}
