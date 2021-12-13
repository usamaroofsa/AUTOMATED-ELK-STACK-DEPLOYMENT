## Automated ELK Stack Deployment
$whoami;

Usama Asfoor

pwd

~/UCB/Cybersecurity/bootcamp/Week13/Project-1



-



#This demonstration will help you deploy an ELK stack on your own and hopefully learn how to eventually configure it to the way you want to.

#"ELK" is an ancronym for a trio of programs that work in sync to help analysts evaluate and visulize information. The "E" is for Elasticsearch, which is a search and analytics engine. The "L" is for Logstash, and it absorbs data from multiple sources simultaneously, organizes it and then sends it to a "stash". And lastly "K" for Kibana. Kibana is a great GUI tool that visualizes data for analysts with charts and graphs of the Elasticsearch. This creates the "ELK Stack" shown in my demonstration

#The VMs Used in this demonstration were deployed using Microsoft Azure, and are run on Ubuntu Linux, you may use a different deployment for VMs if pleased, however must run Ubuntu

#I.P Addresses of the virtual machines shown in this demonstration may vary, and must be adjusted to your new(or already existing) VMs

#The files in this repository were used to configure the network depicted below.


![](Images/ELK-Diagram.png)

#These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the YAML file may be used to install only certain pieces of it, such as Filebeat.

  -[Ansible Config](Ansible/ansible.cfg)
  
  -[Ansible Hosts File](Ansible/Ansible-hosts.txt)
  
  -[ELK Playbook](YAML/elkplaybook.yml)
  
  -[FileBeat Config](YAML/filebeat-configuration.yml)
  
  -[FileBeat Playbook](YAML/filebeat-playbook.yml)
  
  -[MetricBeat Config](YAML/metricbeat-configuration.yml)
  
  -[MetricBeat Playbook](YAML/metricbeat-playbook.yml)



### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will run smoothly , by spliting the traffic between two VMs, it avoids greater probability of an overload crash. It is desired in security because it can mitigate an attack like DDOS, all while maintining a status of accessibility in addittion to restricting outsiders from the network.


#RED-TEAM VN:

First, a Jump Box VM is placed to host containers for the other VMs, allowing access only from the public ip of the users public IP.(You can find yours on whatsmyip.org). Then after the Jump Box, will be two other VMs. The Jump Box will host Ansible, which is used to configure the docker containers that are running on the other two VMs. Run $sudo docker pull cyberxsecurity/ansible to find it. Run the docker next with $docker run -ti cyberxsecurity/ansible:latest bash. Load Balancer handles the traffic split between the two VMs that run the DVWA. cd to /etc/ansible and dowlaod the [DVWA yaml file](/YAML/DVWA.yml). Make sure the the ansible config and hosts are updated. Then run $ansible-playbook DVWA.yml This should have your DVWA running.

The setup shown is a good way to go because it isolates the access between both sides of the files, reducing chances of attacks, and the load balancer helps any overload of data.

The configuration details of each machine in the first virtual network (Red-Team) may be found below.


| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway       | 10.0.0.1(private)/52.168.6.24(public)   | Linux            |
| WEB-1     | Docker Server   | 10.0.0.10           |   Linux               |
| WEB-2    |     Docker Server   |       10.0.0.11     |     Linux             |


#ELK-VN
In a seperate VN, we deploy a single VM, and call it ELK-Server. This is where our ELK will be deployed. Allow the ELK server to be accessed from the Jump Box through SSH.

The configuration details of each machine in the ELK Virtual Network may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| ELK-Server | ELK Gateway  | 10.1.0.4(private)/40.122.247.76(public)  | Linux            |


#Both VNs are peered together in and out

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Ensure that only the Jump Box machine can accept connections from the Internet and that access to this machine is only allowed from the following IP addresses:
<Your.Local.Host.IP>

Machines within the network can only be accessed by The Jump Box and only Jump Box can access the ELK VM.

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box    |       Yes             | <Local.Host.IP.>    |
|    WEB-1      |       No              |             10.0.0.1     |
|    WEB-2      |        No             |             10.0.0.1     |
|   ELK-SERVER |    No             |             10.0.0.1     |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it uses YAML playbooks, which is a great practice for configuration and automation of your container deployment.

ELK YAML playbook could be downloaded below:
![](/YAML/elkplaybook.yml)



To set up the ELK server through the playbook:

First, SSH into the Jump-Box-Provisioner
check for the latest docker image you used ($docker container list -a)
if docker isnt up, run $docker start elk
Use the name of the docker image that is assigned at random. keep in mind to always log back in to the same name, as docker will recycle and creat a new name at random.
Start and Attach the ansible docker ($sudo docker start <docker-name>), ($sudo docker attach <docker-name>)
Add the ELK-Server ip address to the /ansible/hosts file.
Then head to /etc/ansible/roles directory and download the ELK "elkplaybook.yml"
Run the elkplaybook.yml in that same directory using $ansible-playbook elkplaybook.yml
Then SSH into the ELK-SERVER VM to verify the server is up and running by entering the command $sudo docker ps
After "docker ps" you should get the following:

![](Images/dockerps.png)

### Target Machines & Beats
This ELK server is configured to monitor the DVWA in the following machines:

WEB-1 (10.0.0.10)
WEB-2 (10.0.0.11)

Within the ELK Stack we will use FileBeat and MetricBeat.

Filebeat is used as a lightweight shipper for forwarding and centralizing log data. It works great for collecting log files on remote servers.  
Examples of filebeats findings can be files from a SQL database, or authentication history.
On the other hand, Metricbeat collects network metrics and statistics. It tells analysts if the statistics are looking normal and healthy. 
Examples of Metricbeat findings can be user count or memory usage

We will install the following Beats on both of the DVWA machines


### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:

-Edit ansible hosts file to include ELK server
- Copy the filebeat-config.yml file to /etc/ansible/
- Copy the filebeat-playbook.yml file to /etc/ansible
- Copy the metricbeat-config.yml file to /etc/ansible/
- Run both the playbook files with $ansible-playbook <pick-file>, and navigate to Kibana in your browser by entering http://[<ELK.Public.IP>]:5601/app/kibana to check that the installation worked as expected.
- After clicking DEB, Filebeat, and Metricbeat you shall see the following:

![](/Images/MetricSuccess.png) ![](/Images/FileSuccess.png)

- If you are having trouble make sure all your Config files and playbooks are edited to include your user name and ip addresses. Make sure there is ansible_python_interpreter=/usr/bin/python3 after the ip addresses in the ansible hosts file. 
  

  The ELK server is running in a peer'ed VN with the VN with the ansible config files.

- Url to access the Kibana Database http://[<ELK.Public.IP>]:5601/app/kibana

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
After you download the playbook file from the repository, run the command "nano <file-to-edit>". This will let you edit the config and playbook files, which is required so that you can sync it within your own VMs.
After it is edited, you can run the command "ansible-playbook <playbookfile.yml>" this will automatically run the commands in the playbook, while configured to the settings in the related config.yml files.

