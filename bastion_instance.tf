resource "oci_core_instance" "ExampleBastionInstance" {

    availability_domain = var.available_dom
    shape = var.instance_shape

    compartment_id = oci_identity_compartment.ExampleCompartment.id

    source_details {
        source_id = var.instance_image
        source_type = "image"
    }

    display_name = var.instance_name

    metadata = {
        ssh_authorized_keys = file("/root/.ssh/id_rsa.pub")
    }
   
    # for vnics & extracting the public IP

    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.ExampleBastionSubnet.id
    }

  

}
