
locals {
  retry_join = "provider=aws tag_key=NomadJoinTag tag_value=auto-join"
}

resource "aws_instance" "nomad_leader" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.server_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nomad_ui.id, aws_security_group.ssh.id, aws_security_group.nomad_internal.id]
  count                  = var.nomad_leader_count

  connection {
    type        = "ssh"
    user        = "ubuntu"
    #key_name    = var.key_name
    host        = self.public_ip
  }

  # NomadJoinTag is necessary for nodes to automatically join the cluster
  tags = merge(
    {
      "Name" = "tf-${var.company}-${var.name}-${var.environment}-nomad_leader-${count.index}"
    },
    {
      "NomadJoinTag" = "auto-join"
    },
    {
      "NomadType" = "server"
    }
  )

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_block_device_size
    delete_on_termination = "true"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /nomad", "sudo chmod 777 -R /nomad"]
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/nomad"
  }

  user_data = templatefile("scripts/user_data/user_data_server.sh", {
    nomad_leader_count              = var.nomad_leader_count
    region                    = var.region
    cloud_env                 = "aws"
    retry_join                = local.retry_join
    nomad_version             = var.nomad_version
  })
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }
}

resource "aws_instance" "nomad_client" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.client_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nomad_ui.id, aws_security_group.ssh.id, aws_security_group.nomad_client.id, aws_security_group.nomad_internal.id]
  count                  = var.nomad_client_count

  connection {
    type        = "ssh"
    user        = "ubuntu"
    #key_name    = var.key_name
    host        = self.public_ip
  }

  # NomadJoinTag is necessary for nodes to automatically join the cluster
  tags = merge(
    {
      "Name" = "tf-${var.company}-${var.name}-${var.environment}-nomad_client-${count.index}"
    },
    {
      "NomadJoinTag" = "auto-join"
    },
    {
      "NomadType" = "client"
    }
  )

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_block_device_size
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "50"
    delete_on_termination = "true"
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /nomad", "sudo chmod 777 -R /nomad"]
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/nomad"
  }

  user_data = templatefile("scripts/user_data/user_data_client.sh", {
    region                    = var.region
    cloud_env                 = "aws"
    retry_join                = local.retry_join
    nomad_version             = var.nomad_version
  })
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }
}
