resource "oci_core_internet_gateway" "ExampleInternetGateway" {
  compartment_id = oci_identity_compartment.ExampleCompartment.id
  display_name = "ExampleInternetGateway"
  vcn_id = oci_core_virtual_network.ExampleVCN.id
}

