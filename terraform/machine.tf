resource "aws_instance" "privacy_machine" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_size
  key_name = var.ssh_key
  security_groups = [aws_security_group.privacy_sg.name]
  root_block_device {
    volume_size = var.disk
    encrypted = true
    kms_key_id = data.aws_ebs_default_kms_key.current.key_arn
  }
  tags = {
    Name = "privacy_exam"
  }
  #iam_instance_profile = aws_iam_instance_profile.cw_agent_onion_profile.name  # Ver se da tempo, colocar um monitor no CloudWatch
  monitoring = true
  depends_on = [aws_security_group.privacy_sg] # Cascade Destroy  # ,aws_iam_instance_profile.cw_agent_onion_profile
  disable_api_termination = var.ec2_termination # True: Disable Termination
}

resource "aws_security_group" "privacy_sg" {
  name = "privacy_sg"
  description = "Privacy Exam Security Group"

  ingress { #Inbound Rules
    from_port = var.inbound_rules.port
    protocol = var.inbound_rules.protocol
    to_port = var.inbound_rules.port
    cidr_blocks = [var.network.all_ipv4]
    ipv6_cidr_blocks = [var.network.all_ipv6]
    description = var.inbound_rules.description
  }

  egress { # Outbond Rule
    from_port = var.network.all_ports
    protocol = var.network.all_protocols
    to_port = var.network.all_ports
    cidr_blocks = [var.network.all_ipv4]
    ipv6_cidr_blocks = [var.network.all_ipv6]
  }

}

#resource "aws_iam_instance_profile" "cw_agent_onion_profile" {   # Ver se da tempo, colocar um monitor no CloudWatch
#  name = "cw_agent_profile"
#  role = "CwAgentRole"
#}
