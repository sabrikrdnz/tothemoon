
# ToTheSky

Hola! This repository contains some yaml and bash files about creating development environment on k8s using Terraform as IaC and running python app on it!

With this project, i aimed to create a structure where developers can use as dev environment to work on Azure and I used;
- 	Terraform To Create Infrastructure, 
- 	Ansible To Set Up K8s Cluster, 
- 	AzureDevops For CI/CD 

#### Installation the Environment
`$ ./run.sh`

#### Prerequisites

Before execute the script you should provide some informations in terraform.tfvars file. 

    subs_id = "**************************"
    client_id = "****************************"
    client_secret = "****************************"
    tenant_id = "****************************"

![](https://github.com/sabrikrdnz/tothemoon/blob/main/diagram.png)
