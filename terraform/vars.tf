variable "instance_size" {
  type = string
}

variable "network" {
  type = object({
    all_ipv4 = string
    all_ipv6 = string
    all_protocols = string
    all_ports = number
  })

  default = {
    all_ipv4 = "0.0.0.0/0"
    all_ipv6 = "::/0"
    all_protocols = "-1"
    all_ports = 0
  }
}

variable "disk" {
  type = number
}

variable "ssh_key" {
  type = string
  default = "personal"
}

variable "ec2_termination" {
  type = bool
  default = false
}

variable "inbound_rules" {
  type = list(object({
    port = number
    protocol = string
    description = string
  }))
}
