resource "oci_core_dhcp_options" "ExampleDHCPOptions" {

  compartment_id = oci_identity_compartment.ExampleCompartment.id
  vcn_id = oci_core_virtual_network.ExampleVCN.id
  display_name = "ExampleDHCPOptions"

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type = "SearchDomain"
    search_domain_names = ["bastionexample.com"]
  }

 }

