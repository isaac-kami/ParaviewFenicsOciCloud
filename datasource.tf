# get a list of vnic attachments for Bastion

 data "oci_core_vnic_attachments" "ExampleBastionVNICs" {
       compartment_id = oci_identity_compartment.ExampleCompartment.id
       availability_domain = var.available_dom
       instance_id = oci_core_instance.ExampleBastionInstance.id
  }

# get the primary VNIC ID for Bastion

  data "oci_core_vnic" "ExampleBastionVNICprimary" {
     vnic_id = lookup(data.oci_core_vnic_attachments.ExampleBastionVNICs.vnic_attachments[0], "vnic_id")
  }


# get a list of vnic attachments for Fenics host

 data "oci_core_vnic_attachments" "FenicsInstanceVNICs" {
       compartment_id = oci_identity_compartment.ExampleCompartment.id
       availability_domain = var.available_dom
       instance_id = oci_core_instance.FenicsInstance.id
}

  data "oci_core_vnic" "FenicsInstanceVNICprimary" {
     vnic_id = lookup(data.oci_core_vnic_attachments.FenicsInstanceVNICs.vnic_attachments[0], "vnic_id")
  }

# get a lit of vnic attachments for Paraview host


 data "oci_core_vnic_attachments" "ParaviewInstanceVNICs" {
      compartment_id = oci_identity_compartment.ExampleCompartment.id
      availability_domain = var.available_dom
      instance_id = oci_core_instance.ParaviewInstance.id
}

  data "oci_core_vnic" "ParaviewInstanceVNICprimary" {
     vnic_id = lookup(data.oci_core_vnic_attachments.ParaviewInstanceVNICs.vnic_attachments[0], "vnic_id")
  }
