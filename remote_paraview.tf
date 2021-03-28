resource "null_resource" "ExampleParaview" {

  depends_on = [oci_core_instance.ParaviewInstance, oci_core_instance.ExampleBastionInstance]

  provisioner "remote-exec" {
    inline = ["echo I am in ", 
              "hostname", 
              "sleep 10",
              "sudo apt update",
              "sudo apt install -y firewalld",
              "sudo firewall-cmd --add-port=11111/tcp --permanent",
              "sudo firewall-cmd --reload",
              "sudo apt update",
              "sudo  apt install -y build-essential",
              "sudo apt -y install qtcreator",
	      "sudo apt -y install qtcreator-doc",
	      "sudo apt -y install qt5-default",
              "sudo apt -y install qt5-doc",
	      "sudo apt -y install qt5-doc-html",
              "sudo apt -y install -yqtbase5-doc-html",
	      "sudo apt -y install qtbase5-examples",
	      "sudo apt -y install qtdeclarative5-dev",
	      "sudo apt -y install qtbase5-dev",
	      "sudo apt -y install qtbase5-doc",
	      "sudo apt -y install qtxmlpatterns5-dev-tools",
	      "sudo apt -y install cmake",
	      "sudo apt -y install libgl1-mesa-dev",
	      "sudo apt -y install git",
	      "sudo apt -y install libxt-dev",
              "sudo apt -y install qt5-default",
              "sudo apt -y install libqt5x11extras5-dev",
	      "sudo apt -y install libqt5help5",
	      "sudo apt -y install qttools5-dev",
	      "sudo apt -y install qtxmlpatterns5-dev-tools", 
              "sudo apt -y install libqt5svg5-dev",
              "sudo apt -y install python3-dev", 
              "sudo apt -y install python3-numpy", 
	      "sudo apt -y install libopenmpi-dev", 
              "sudo apt -y install libtbb-dev",
 "sudo wget -O /opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit.tar.gz 'https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.9&type=binary&os=Linux&downloadFile=ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit.tar.gz' --quiet",
"sudo tar -xvf /opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit.tar.gz -C /opt"]

    
    connection {
      type = "ssh"
      user = "ubuntu"
      host = data.oci_core_vnic.ParaviewInstanceVNICprimary.private_ip_address
      private_key = file(var.private_key_path)

      bastion_host = data.oci_core_vnic.ExampleBastionVNICprimary.public_ip_address
      bastion_port = var.port_bastion
      bastion_user = "ubuntu"
      bastion_private_key = file(var.private_key_path)
      
   } 

  }

}
