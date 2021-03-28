resource "oci_objectstorage_bucket" "example_bucket" {

    compartment_id = oci_identity_compartment.ExampleCompartment.id
    name = var.name_bucket
    namespace = var.bucket_namespace
    storage_tier = "Standard"
}
