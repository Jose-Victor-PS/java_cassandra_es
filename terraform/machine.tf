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
  monitoring = true
  depends_on = [aws_security_group.privacy_sg] # Cascade Destroy  # ,aws_iam_instance_profile.cw_agent_onion_profile
  disable_api_termination = var.ec2_termination # True: Disable Termination
}

resource "aws_security_group" "privacy_sg" {
  name = "privacy_sg"
  description = "Privacy Exam Security Group"
}

resource "aws_security_group_rule" "privacy_sg_ingress" {
  count = length(var.inbound_rules)
  type              = "ingress"
  from_port         = var.inbound_rules[count.index].port
  to_port           = var.inbound_rules[count.index].port
  protocol          = var.inbound_rules[count.index].protocol
  cidr_blocks       = [var.network.all_ipv4]
  ipv6_cidr_blocks  = [var.network.all_ipv6]
  security_group_id = aws_security_group.privacy_sg.id
  description = var.inbound_rules[count.index].description
}

resource "aws_security_group_rule" "privacy_sg_egress" {
  type              = "egress"
  from_port         = var.network.all_ports
  to_port           = var.network.all_ports
  protocol          = var.network.all_protocols
  cidr_blocks       = [var.network.all_ipv4]
  ipv6_cidr_blocks  = [var.network.all_ipv6]
  security_group_id = aws_security_group.privacy_sg.id
}
