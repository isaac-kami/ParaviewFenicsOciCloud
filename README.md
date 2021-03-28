# Paraview and Fenics in OCI



<b>Prerequisites for deploying this architecture with Terraform:</b>
  <br></br>

- an Oracle cloud account - You can sign up for a 30 free days trial, at Oracle Cloud Free Tier
- setting up OCI CLI. You can check this tutorial <a href="https://isaac-exe.gitbook.io/various-tutorials/tutorials/1.-deployment-instance/install-and-configure-oci-cli#2-configure-oci-cli">Configure OCI CLI </a>
- setting up Terraform on the machine from which you make the deployment. You can check this tutorial <a href="https://isaac-exe.gitbook.io/various-tutorials/tutorials/1.-deployment-instance/install-and-configure-terraform">Install and Configure Terraform</a>

<br></br>
<b>Architecture</b>

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/arch.jpg)

<br></br>
How to deploy:

<i> Before deploying, make sure:
- you check the variables.tf and provide the necessary information (such as tenancy OCID, etc) 
- if needed, change the public ssh keys path for instances; is setup as:  </i>
```
  metadata = {
        ssh_authorized_keys = file("/root/.ssh/id_rsa.pub")
    }
```

Configure, check and apply changes with the usual Terraform commands:

```
terraform init
terraform validate
terraform plan
terraform apply
```

<br></br>
What the Terraform code will implement:

- create a compartment and a VCN
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/n1.png)
- create an Internet Gateway
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/n5.png)
- create a NAT Gateway
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/n6.png)
- create a Service Gateway
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/n4.png)
- create an Object Storage Bucket
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/b2.png)
- deploy an instance (public IP) in a public subnet behind Internet Gateway - this instance will represent the Bastion
  <br></br>
- deploy two  instances (private IPs) in a private subnet behind a NAT Gateway
  <br></br>
- provision the two private instances with the two applications,  Paraview (server), respectively Fenics
  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/ins1.png)
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/n2.png)

  <br></br>

<i> As already stated, for Paraview and Fenics, the setup and dependencies configuration are done automatically. </i>

<b> Steps after deploying the architecture: </b>

The "terraform apply" will provide the following output (obviously, the IPs will be changed on your side. Treat this as an example)

```

Terraform output:

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

PrivateIpFenics = [
  "10.0.2.2",
]
PrivateIpParaview = [
  "10.0.2.3",
]
PublicIpBastion = [
  "129.159.250.195",
]

```

To access the Private Hosts (Fenics and Paraview), you will need to ssh through the bastion:

<i> Syntax </i>:
```
ssh -J ubuntu@bastion ubuntu@privatehost
```

- to access Fenics host:

```
root@deploymentmachine:/home/ParaviewFenicsOCI# ssh -J ubuntu@129.159.250.195 ubuntu@10.0.2.2
The authenticity of host '10.0.2.2 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.2.2' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

 [.... snip .... ]

 ubuntu@fenics-instance:~$
 ubuntu@fenics-instance:~$
 
```

- to access Paraview host


```
root@deploymentmachine:/home/ParaviewFenicsOCI# ssh -J ubuntu@129.159.250.195 ubuntu@10.0.2.3
The authenticity of host '10.0.2.3 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.2.3' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

 [.... snip .... ]

 ubuntu@paraview-instance:~$
 ubuntu@paraview-instance:~$
```

<br></br>

<b>Fenics and Paraview hosts to access the Object Storage</b>


To access the Object Storage from Fenics instance and Paraview instance, configure OCI CLI on both of them.
Make sure you add the public .pem key in the User/API Keys from OCI Cloud , otherwise you will not be able to upload or download to/from the Bucket.

For setting up the OCI CLI and the API Keys in Oracle Cloud, follow this tutorial: <a href="https://isaac-exe.gitbook.io/various-tutorials/tutorials/1.-deployment-instance/install-and-configure-oci-cli#2-configure-oci-cli">Configure OCI CLI </a>


Perform a few tests to check if configuration was properly done:

```
root@paraview-instance:/home# oci os bucket get --bucket-name examplebucket
{
  "data": {
    "approximate-count": null,
    "approximate-size": null,
    "compartment-id": "ocid1.compartment.oc1..a",
    "created-by": "ocid1.user.oc1..a",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "zack@mail.com",
        "CreatedOn": "2021-03-27T16:13:04.943Z"
      }
    },
    "etag": c,
    "freeform-tags": {},
    "id": "ocid1.bucket.oc1.eu-frankfurt-1.aa",
    "is-read-only": false,
    "kms-key-id": null,
    "metadata": {},
    "name": "examplebucket",
    "namespace": " ",
    "object-events-enabled": false,
    "object-lifecycle-policy-etag": null,
    "public-access-type": "NoPublicAccess",
    "replication-enabled": false,
    "storage-tier": "Standard",
    "time-created": "2021-03-27T16:13:04.953000+00:00",
    "versioning": "Disabled"
  },
  "etag": 
}
root@paraview-instance:/home#
```
<br> </br>


<b> Testing environment - Paraview and Fenics </b>


a) On the Fenics instance, create the output files that can be represented graphically in Paraview Client

The code example for solving a Poisson problem can be found at below tutorial (page 13):
https://fenicsproject.org/pub/course/lectures/2017-nordic-phdcourse/lecture_20_tools_for_visualisation.pdf


As a reminder, the Fenics application has been configured and properly installed with Terraform code. 
For more details, check code for <i>remote_fenics.tf</i>


```
root@deploymentmachine:/home/ParaviewFenicsOCI# ssh -J ubuntu@129.159.250.195 ubuntu@10.0.2.2
The authenticity of host '10.0.2.2 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.2.2' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

 [.... snip .... ]

 ubuntu@fenics-instance:~$
 ubuntu@fenics-instance:~$ sudo -i
 root@fenics-instance:~#
 root@fenics-instance:~# python3 -c "import dolfin as dolf ; print(dolf.__version__)"
 2019.2.0.dev0
 root@fenics-instance:~#
```
<br></br>
<b>Implementing the Poisson example code from page 13</b>

Suppose you run this code under folder /opt/test:

```
root@fenics-instance:/opt/test# python3
Python 3.8.5 (default, Jul 28 2020, 12:59:40)
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from  dolfin  import *
>>> mesh = UnitCubeMesh(16, 16, 16)
>>> V = FunctionSpace(mesh , "P", 1)
>>> u = TrialFunction(V)
>>> v = TestFunction(V)
>>> f = Constant(1.0)
>>> a = inner(grad(u), grad(v)) * dx
>>> L = f * v * dx
>>> bc = DirichletBC(V, 0.0, "on_boundary")
>>> uh = Function(V)
>>> solve(a == L, uh , bc)
Calling FFC just-in-time (JIT) compiler, this may take some time.
Calling FFC just-in-time (JIT) compiler, this may take some time.
Calling FFC just-in-time (JIT) compiler, this may take some time.
Calling FFC just-in-time (JIT) compiler, this may take some time.
Calling FFC just-in-time (JIT) compiler, this may take some time.
Solving linear variational problem.
>>> file = XDMFFile("output.xdmf")
>>> file.write(uh, 0)
>>> file = File("output.pvd")
>>> file << uh
>>> exit()
root@fenics-instance:/opt/test#
```
<br></br>
Output files obtained (yes, I generated all the mentioned files from the tutorial):

```
root@fenics-instance:/opt/test# ls -ltr
total 1456
-rw-r--r-- 1 root root    918 Mar 27 18:42 output.xdmf
-rw-r--r-- 1 root root 556976 Mar 27 18:42 output.h5
-rw-r--r-- 1 root root 923593 Mar 27 18:42 output000000.vtu
-rw-r--r-- 1 root root    168 Mar 27 18:42 output.pvd
root@fenics-instance:/opt/test#
```
<br></br>
Upload files to Object Storage, in bucket "examplebucket":

```

root@fenics-instance:/opt/test# oci os object bulk-upload --bucket-name examplebucket --src-dir /opt/test
Uploaded output.pvd  [####################################]  100%
Uploaded output.h5  [####################################]  100%
Uploaded output000000.vtu  [####################################]  100%
Uploaded output.xdmf  [####################################]  100%

{
  "skipped-objects": [],
  "upload-failures": {},
  "uploaded-objects": {
    "output.h5": {
      "etag": "f9a5f9da-a9f1-4da9-939d-2d60814f35e0",
      "last-modified": "Sat, 27 Mar 2021 19:07:02 GMT",
      "opc-content-md5": "pDAdU3cQIWnylLnZ8oYboA=="
    },
    "output.pvd": {
      "etag": "044d7630-0b43-4ac9-853a-006b1ebd47db",
      "last-modified": "Sat, 27 Mar 2021 19:07:02 GMT",
      "opc-content-md5": "jGhIxS9Wid33yBlX0oQ0gw=="
    },
    "output.xdmf": {
      "etag": "2a8f32d0-e4ae-42ac-9709-d5f020a71214",
      "last-modified": "Sat, 27 Mar 2021 19:07:02 GMT",
      "opc-content-md5": "9YWs+JXtlBT1msEthg6+Jw=="
    },
    "output000000.vtu": {
      "etag": "84f22790-3295-4168-bb88-33d1ea619ccb",
      "last-modified": "Sat, 27 Mar 2021 19:07:02 GMT",
      "opc-content-md5": "KVQR4U6IO7Dnab6CI5ZGww=="
    }
  }
}

```
<br></br>
Perform a check from command line, by listing the objects from bucket "examplebucket":
```
root@fenics-instance:/opt/test# oci os object list -bn examplebucket
{
  "data": [
    {
      "archival-state": null,
      "etag": "f9a5f9da-a9f1-4da9-939d-2d60814f35e0",
      "md5": "pDAdU3cQIWnylLnZ8oYboA==",
      "name": "output.h5",
      "size": 556976,
      "storage-tier": "Standard",
      "time-created": "2021-03-27T19:07:02.270000+00:00",
      "time-modified": "2021-03-27T19:07:02.302000+00:00"
    },
    {
      "archival-state": null,
      "etag": "044d7630-0b43-4ac9-853a-006b1ebd47db",
      "md5": "jGhIxS9Wid33yBlX0oQ0gw==",
      "name": "output.pvd",
      "size": 168,
      "storage-tier": "Standard",
      "time-created": "2021-03-27T19:07:02.258000+00:00",
      "time-modified": "2021-03-27T19:07:02.268000+00:00"
    },
    {
      "archival-state": null,
      "etag": "2a8f32d0-e4ae-42ac-9709-d5f020a71214",
      "md5": "9YWs+JXtlBT1msEthg6+Jw==",
      "name": "output.xdmf",
      "size": 918,
      "storage-tier": "Standard",
      "time-created": "2021-03-27T19:07:02.634000+00:00",
      "time-modified": "2021-03-27T19:07:02.641000+00:00"
    },
    {
      "archival-state": null,
      "etag": "84f22790-3295-4168-bb88-33d1ea619ccb",
      "md5": "KVQR4U6IO7Dnab6CI5ZGww==",
      "name": "output000000.vtu",
      "size": 923593,
      "storage-tier": "Standard",
      "time-created": "2021-03-27T19:07:02.318000+00:00",
      "time-modified": "2021-03-27T19:07:02.413000+00:00"
    }
  ],
  "prefixes": []
}

```

... and perform a check in the OCI Cloud:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/b3.png)



b) <b> Paraview host </b>


As already mentioned, you don't need to install or configure anything at this step;
setting up the Paraview and all the dependencies is done from the Terraform code (you can check <i>remote_paraview.tf</i> for more details)

All Paraview files and folders can be found at location /opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit of the paraview-instance host:

```
root@paraview-instance:/opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit# ls -ltr
total 52
drwxr-xr-x 2 root root  4096 Jan 23 18:45 bin
drwxr-xr-x 3 root root  4096 Jan 23 18:45 share
drwxr-xr-x 6 root root 45056 Jan 23 18:45 lib
root@paraview-instance:/opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit#
```
<br></br>

Perform following steps:

b1) Download files from bucket under a certain location. These files will be vizualized from that specific location by using Paraview Client.

Suppose the files from the bucket will be downloaded under /opt/bucketexample:

```
root@deploymentmachine:/home/ParaviewFenicsOCI# ssh -J ubuntu@129.159.250.195 ubuntu@10.0.2.3
The authenticity of host '10.0.2.3 (<no hostip for proxy command>)' can't be established.
ECDSA key fingerprint is SHA256:
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.0.2.3' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

 [.... snip .... ]

ubuntu@paraview-instance:~$
ubuntu@paraview-instance:~$ sudo -i
root@paraview-instance:~# cd /opt
root@paraview-instance:/opt# mkdir bucketexample
root@paraview-instance:/opt# cd bucketexample/
root@paraview-instance:/opt/bucketexample# /root/bin/oci os object bulk-download --bucket-name examplebucket --download-dir /opt/bucketexample
Downloaded output.h5  [####################################]  100%
Downloaded output.xdmf  [####################################]  100%
Downloaded output.pvd  [####################################]  100%
Downloaded output000000.vtu  [####################################]  100%

{
  "download-failures": {},
  "skipped-objects": []
}
root@paraview-instance:/opt/bucketexample# ls -ltr
total 1456
-rw-r--r-- 1 root root 556976 Mar 27 19:26 output.h5
-rw-r--r-- 1 root root    918 Mar 27 19:26 output.xdmf
-rw-r--r-- 1 root root    168 Mar 27 19:26 output.pvd
-rw-r--r-- 1 root root 923593 Mar 27 19:26 output000000.vtu
root@paraview-instance:/opt/bucketexample#

```
<br></br>
b2) Start the Paraview Server

All you need to do at this step is to start the Paraview server, so that it can start listening on port 11111:

```
root@paraview-instance:/opt/ParaView-5.9.0-osmesa-MPI-Linux-Python3.8-64bit/bin#                                                    ./pvserver
Waiting for client...
Connection URL: cs://paraview-instance:11111
Accepting connection(s): paraview-instance:11111

```
<br></br>

<b> SSH Tunneling and Portforwarding </b>

Now that the Paraview server is running, you need to create a connection with a Paraview Client. 

I suppose many of you have an idea of how to create SSH Tunneling and Port-Forwarding (since this a general requirement in the technical world),
so I will not focus on the basics.

Steps:

a) On the machine from which you did the deployment/running Terraform code, 
you will need to create a ssh configuration file that will allow ssh tunneling and port forwarding (change IPs accordingly to your Terraform output)

The ssh config file my have the following content:
```
root@deploymentmachine:~# more ~/.ssh/config
Host bastion
Hostname 129.159.250.195
User ubuntu
IdentityFile ~/.ssh/id_rsa

Host para
Hostname 10.0.2.3
User ubuntu
IdentityFile ~/.ssh/id_rsa
ProxyCommand ssh -i ~/.ssh/id_rsa bastion -W %h:%p %r
LocalForward 11111 10.0.2.3:11111

Host fenics
Hostname 10.0.2.2
User ubuntu
IdentityFile ~/.ssh/id_rsa
ProxyCommand ssh -i ~/.ssh/id_rsa bastion -W %h:%p %r

```
<br></br>
On bastion host, enable the port-forwarding:

```
root@bastioninstance:~# cat /proc/sys/net/ipv4/ip_forward
0
root@bastioninstance:~# echo 1 >  /proc/sys/net/ipv4/ip_forward
root@bastioninstance:~#  cat /proc/sys/net/ipv4/ip_forward
1
root@bastioninstance:~#
```

Check if ssh tunneling is properly configured by running:
```
root@deploymentmachine:~#  ssh fenics
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

[... snip... ]

*** System restart required ***
Last login: Sun Mar 28 15:38:53 2021 from 10.0.1.2
ubuntu@fenics-instance:~$
ubuntu@fenics-instance:~$
```

```
root@deploymentmachine:~#ssh bastion
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

[ ... snip ...]

ubuntu@bastioninstance:~$
ubuntu@bastioninstance:~$
```
<br></br>

```
root@deploymentmachine:~#  ssh fenics
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)

[... snip... ]

*** System restart required ***
Last login: Sun Mar 28 15:38:53 2021 from 10.0.1.2
ubuntu@paraview-instance:~$
ubuntu@paraview-instance:~$
```


<br></br>
b) Make port 11111 listening on instance from which you deployed:

```
root@deploymentmachine:~# ssh -R 11111:127.0.0.1:11111 para
```

<br></br>
Check:= status of the port
```
root@deploymentmachine:~# lsof -i :11111
COMMAND     PID USER   FD   TYPE   DEVICE SIZE/OFF NODE NAME
ssh     1206788 root    3u  IPv6 22246025      0t0  TCP ip6-localhost:11111 (LISTEN)
ssh     1206788 root    6u  IPv4 22246026      0t0  TCP localhost:11111 (LISTEN)
root@deploymentmachine:~#
root@deploymentmachine:~#
```
<br></br>
c) Now, on your computer (the local computer on which there is installed Paraview Client with GUI), you also need to put port 11111 in Listening State:

```
root@ZACK:~# ssh -L 11111:127.0.0.1:11111 ubuntu@<IP of deploymentmachine>
```

Check if port 11111 is listening on your personal laptop/computer (here, Windows 10 OS):


```
PS C:\Users\ZACK> get-nettcpconnection | where {($_.State -eq "Listen") -and ($_.LocalPort -eq "11111")}

LocalAddress                        LocalPort RemoteAddress                       RemotePort State       AppliedSetting OwningProcess
------------                        --------- -------------                       ---------- -----       -------------- -------------
::1                                 11111     ::                                  0          Listen                     11384
127.0.0.1                           11111     0.0.0.0                             0          Listen                     11384


PS C:\Users\TekAdvice>
```

<br></br>
Start the Paraview Client and access the Paraview Server on port 11111:

a) Add server in Paraview Client and connect to it:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para1.png)

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para2.png)

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para3.png)

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para4.png)

<br></br>
b) When Paraview connects, the Paraview Server should print the "Client connected" message, to validate the connection:
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para5.png)


<br></br>

c) From the Paraview Client, go the the folder location on the Paraview Server, where the output files were downloaded from the bucket:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para8.png)

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para9.png)

d) Import the file, and you should see the Cube mesh:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para10.png)

e) When you disconnect from Paraview client, the Paraview server will output the connection as closed:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b1/para11.png)


