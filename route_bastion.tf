resource "oci_core_route_table" "ExampleBastionRouteTable" {

  compartment_id = oci_identity_compartment.ExampleCompartment.id
  vcn_id = oci_core_virtual_network.ExampleVCN.id
  display_name = "ExampleRouteTable"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ExampleInternetGateway.id
  }
}

