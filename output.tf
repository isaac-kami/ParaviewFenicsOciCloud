
output "PublicIpBastion" {

value = [data.oci_core_vnic.ExampleBastionVNICprimary.public_ip_address]

}

output "PrivateIpFenics" {

value = [data.oci_core_vnic.FenicsInstanceVNICprimary.private_ip_address]

}

output "PrivateIpParaview" {

value = [data.oci_core_vnic.ParaviewInstanceVNICprimary.private_ip_address]

}
