resource "oci_core_security_list" "ExampleBastionSecurityList" {

# bastion should have
# port 22 only

  compartment_id = oci_identity_compartment.ExampleCompartment.id

  display_name = "ExampleBastionSecurityList"

  vcn_id = oci_core_virtual_network.ExampleVCN.id

  egress_security_rules {
    stateless = false
    protocol = "6"
    destination = "0.0.0.0/0"
 }


   ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"

    tcp_options {
      min = var.port_bastion
      max = var.port_bastion
    }
  } 



 ingress_security_rules {
    stateless = false
    protocol = "6"
    source = var.cidr_ingress
  }

}

