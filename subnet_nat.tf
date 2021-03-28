resource "oci_core_subnet" "ExampleNATSubnet"{

  cidr_block = var.cidrsubnet_nat
  compartment_id = oci_identity_compartment.ExampleCompartment.id
  vcn_id = oci_core_virtual_network.ExampleVCN.id

  display_name = "ExampleNATSubnet"
  prohibit_public_ip_on_vnic = true
  
  # security list

  security_list_ids = [oci_core_security_list.ExampleNATSecurityList.id]


  # route table

  route_table_id = oci_core_route_table.ExampleNATRouteTable.id
  
  # dhcp
  dhcp_options_id = oci_core_dhcp_options.ExampleDHCPOptions.id
  
  # dns
  dns_label = "ExampleNAT"
  
}
