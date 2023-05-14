variable "name" {
  description = "Prefix used to name various infrastructure components. Alphanumeric characters only."
  default     = "nomad"
}

variable "region" {
  description = "The AWS region to deploy to."
}

variable "allowed_ip" {
  description = "IP to allow access for the security groups (set 0.0.0.0/0 for world)"
  default     = "0.0.0.0/0"
}

variable "server_instance_type" {
  description = "The AWS instance type to use for servers."
  default     = "t2.micro"
}

variable "client_instance_type" {
  description = "The AWS instance type to use for clients."
  default     = "t2.micro"
}

variable "nomad_leader_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "nomad_client_count" {
  description = "The number of clients to provision."
  default     = "2"
}

variable "root_block_device_size" {
  description = "The volume size of the root block device."
  default     = 16
}

variable "nomad_version" {
  description = "The version of the Nomad binary to install."
  default     = "1.5.0"
}

variable "deployed_by" {
    description = "Deployment code provider that deployed asset for lookup"
    type = string 
    default = ""
}

variable "key_name" {
    description = "Key Name for EC2"
    type = string 
    default = ""
}

variable "company" {
    description = "Company or product"
    type = string
    default = ""
}

variable "environment" {
    description = "Environment of deployment"
    default = "infra"
    type = string
}

