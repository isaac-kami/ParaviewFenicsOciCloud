resource "null_resource" "ExampleFenics" {

  depends_on = [oci_core_instance.FenicsInstance, oci_core_instance.ExampleBastionInstance]

  provisioner "remote-exec" {
    inline = ["echo I am in ", 
              "hostname", 
              "sudo apt update",
              "sudo  apt install -y build-essential",
              "sudo apt update",
              "sudo apt install -y firewalld",
              "sudo firewall-cmd --add-port=11111/tcp --permanent",
              "sudo firewall-cmd --reload",
              "sudo apt update",
              "sudo apt install -y --no-install-recommends software-properties-common",
              "sudo apt update",
              "echo -ne '\n' | sudo add-apt-repository ppa:fenics-packages/fenics",
              "sudo apt update",
              "sudo apt install -y --no-install-recommends fenics"]
    
    connection {
      type = "ssh"
      user = "ubuntu"
      host = data.oci_core_vnic.FenicsInstanceVNICprimary.private_ip_address
      private_key = file(var.private_key_path)

      bastion_host = data.oci_core_vnic.ExampleBastionVNICprimary.public_ip_address
      bastion_port = var.port_bastion
      bastion_user = "ubuntu"
      bastion_private_key = file(var.private_key_path)
      
   } 

  }
}
