
data "oci_objectstorage_bucket" "bucketstuff" {
   name = var.name_bucket
   namespace = var.bucket_namespace
} 

data "oci_core_services" "example_services" {
}


resource "oci_core_service_gateway" "bucket_SVG" {

    compartment_id = oci_identity_compartment.ExampleCompartment.id
    services {

        service_id = data.oci_core_services.example_services.services.1.id

    }
    vcn_id = oci_core_virtual_network.ExampleVCN.id

    display_name = "examplebucket service gateway"
}

resource "oci_core_route_table" "examplebucket_route" {

    compartment_id = oci_identity_compartment.ExampleCompartment.id
    vcn_id = oci_core_virtual_network.ExampleVCN.id
    
    
  route_rules  {
        destination =  lookup(data.oci_core_services.example_services.services[1],"cidr_block")
        destination_type = "SERVICE_CIDR_BLOCK"
        network_entity_id = oci_core_service_gateway.bucket_SVG.id
       }

}
