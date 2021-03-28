resource "oci_core_route_table" "ExampleNATRouteTable" {
  
   display_name = "NAT Route Table"
  
   compartment_id = oci_identity_compartment.ExampleCompartment.id
   vcn_id = oci_core_virtual_network.ExampleVCN.id
   
   route_rules {
     destination = "0.0.0.0/0"
     network_entity_id = oci_core_nat_gateway.ExampleNATGateway.id
   } 
}

   
