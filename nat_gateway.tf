resource "oci_core_nat_gateway" "ExampleNATGateway" {
  compartment_id = oci_identity_compartment.ExampleCompartment.id
  display_name = "Example NAT gateway"
  vcn_id = oci_core_virtual_network.ExampleVCN.id
}
