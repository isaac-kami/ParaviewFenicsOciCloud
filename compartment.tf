resource "oci_identity_compartment" "ExampleCompartment" {
    compartment_id = var.compartment_ocid
    description = "Compartment for Example"
    name = "ExampleCompartment"
}
