# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "ken-mac"
  public_key = "${file("${var.key_path}")}"
}
locals {

  user_data = <<-EOT
  #!/bin/bash
  mkdir /opt/scripts
  cd /opt/scripts
  aws s3 cp s3://mongodb-repo/mongo-setup.sh .
  aws s3 cp s3://mongodb-repo/s3-backup.sh .
  sudo sh /opt/scripts/mongo-setup.sh
  sudo sh /opt/scripts/s3-backup.sh
  EOT
  tags = {
    Owner       = "Kenny"
    Team = "mongodb-server"
  }
}


resource "aws_iam_role" "admin_role" {
  name = "admin_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "admin_profile" {
  name = "admin_profile"
  role = "${aws_iam_role.admin_role.name}"
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = "${aws_iam_role.admin_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "mongodb-server"

  ami                    = var.ami-id
  instance_type          = var.instance_type
  key_name               = "${aws_key_pair.default.id}"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data_base64       = base64encode(local.user_data)
  iam_instance_profile   = "${aws_iam_instance_profile.admin_profile.name}"

tags = {
  Terraform   = "true"
  Environment = "dev"
}
}
