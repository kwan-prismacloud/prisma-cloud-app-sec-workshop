resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_host"
    yor_trace            = "ab171558-3658-42de-80cf-a42b1100e975"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.region}a"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply 
  size = 1

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_host_storage"
    yor_trace            = "bc8fbfb3-c67a-44b3-81d8-f3d56fede202"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "example_snapshot"
    yor_trace            = "912f7495-5194-4070-85c0-2174a7044d4b"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  instance_id = "${aws_instance.web_host.id}"
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web-node"
    yor_trace            = "f580de83-f4b6-4f62-9adf-365ef1f801b2"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_vpc"
    yor_trace            = "5cfe1782-9ecb-4514-b0d2-8a02561e6368"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true


  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_subnet"
    yor_trace            = "15a778a5-beb5-4d85-a51e-eb8f6fd5aaee"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true


  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_subnet2"
    yor_trace            = "e4576c29-f297-4a08-bc2b-77d5877bff74"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_igw"
    yor_trace            = "93605f49-8e0a-447b-8ea4-449110ee3bd4"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web_rtb"
    yor_trace            = "2faff7d0-9edc-42b6-83be-298d56f0e142"
  }
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "web-eni"
    yor_trace            = "84148f57-f9df-441d-8346-3e6aaa90bfdd"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "vpcflowlogs"
    yor_trace            = "c11596f0-0910-44d7-a08e-a8b9a6667dd3"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/deployment_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "flowbucket"
    yor_trace            = "52f04166-8c21-458d-90a4-8cbcf8bb88c1"
  }
}

# OUTPUTS
output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}
