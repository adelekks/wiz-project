# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "ken-mac"
  public_key = "${file("${var.key_path}")}"
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

# Define bitbucket-server inside the public subnet
resource "aws_instance" "mongodb" {
  ami                    = var.ami-id
  instance_type          = var.instance_type
  key_name               = "${aws_key_pair.default.id}"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile = "${aws_iam_instance_profile.admin_profile.name}"

# Login to the ec2-user with the aws key.
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("${var.key_path_priv}")}"
    host        = self.public_ip
  }

# copy Mongodb script to the server
  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }

# Change permissions on bash script and execute from ec2-user
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/scripts/mongo-setup.sh",
      "sudo /tmp/scripts/mongo-setup.sh",
      "sudo sh /tmp/scripts/s3-backup.sh"
    ]
  }

tags          = {
  Name        = "mongodb-server"
  Terraform   = "true"
  Environment = "dev"
 }
}
