resource "oci_core_subnet" "ExampleBastionSubnet"{

  cidr_block = var.cidrsubnet_internet
  compartment_id = oci_identity_compartment.ExampleCompartment.id
  vcn_id = oci_core_virtual_network.ExampleVCN.id

  display_name = "ExampleBastionSubnet"
  
  # security list

  security_list_ids = [oci_core_security_list.ExampleBastionSecurityList.id]

  # route table

  route_table_id = oci_core_route_table.ExampleBastionRouteTable.id
  
  # dhcp
  dhcp_options_id = oci_core_dhcp_options.ExampleDHCPOptions.id
  
  # dns
  dns_label = "ExampleBastion"
  
}
