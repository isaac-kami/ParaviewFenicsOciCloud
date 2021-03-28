resource "oci_core_security_list" "ExampleNATSecurityList" {

# bastion should have
# port 22 only

  compartment_id = oci_identity_compartment.ExampleCompartment.id

  display_name = "ExampleNATSecurityList"

  vcn_id = oci_core_virtual_network.ExampleVCN.id

  egress_security_rules {
    stateless = false
    protocol = "6"
    destination = "0.0.0.0/0"
 }


   dynamic "ingress_security_rules" {
    for_each = toset(var.port_nat)
      content {
        protocol = "6"
        source = "0.0.0.0/0"
        tcp_options {
           max = ingress_security_rules.value
           min = ingress_security_rules.value
       }
    }
  }


}

