packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

#Elasticsearch AMI
variable "elasticsearch_ami_name" {
  type    = string
  default = "Elasticsearch_AMI"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "Elasticsearch-web-server" {
  ami_name                    = "${var.elasticsearch_ami_name}-${local.timestamp}"
  instance_type               = "t2.large"
  region                      = "eu-west-1"
  vpc_id                      = "vpc-0c5401cf49bc67425"
  subnet_id                   = "subnet-049472b14fea66156"
  security_group_id           = "sg-00bd3b3247f5f8294"
  deprecate_at                = timeadd(timestamp(), "8766h")
  force_deregister            = "true"
  force_delete_snapshot       = "true"
  associate_public_ip_address = true


  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

#Kibana AMI
variable "kibana_ami_name" {
  type    = string
  default = "Kibana_Ami"
}

source "amazon-ebs" "Kibana-web-server" {
  ami_name              = "${var.kibana_ami_name}-${local.timestamp}"
  instance_type         = "t2.micro"
  region                = "eu-west-1"
  vpc_id                = "vpc-0c5401cf49bc67425"
  subnet_id             = "subnet-049472b14fea66156"
  security_group_id     = "sg-00bd3b3247f5f8294"
  deprecate_at          = timeadd(timestamp(), "8766h")
  force_deregister      = "true"
  force_delete_snapshot = "true"

  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

#Logstash AMI
variable "logstash_ami_name" {
  type    = string
  default = "Logstash_Ami"
}

source "amazon-ebs" "Logstash-web-server" {
  ami_name              = "${var.logstash_ami_name}-${local.timestamp}"
  instance_type         = "t2.micro"
  region                = "eu-west-1"
  vpc_id                = "vpc-0c5401cf49bc67425"
  subnet_id             = "subnet-049472b14fea66156"
  security_group_id     = "sg-00bd3b3247f5f8294"
  deprecate_at          = timeadd(timestamp(), "8766h")
  force_deregister      = "true"
  force_delete_snapshot = "true"

  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

#Filebeat AMI
variable "filebeat_ami_name" {
  type    = string
  default = "Filebeat_Ami"
}

source "amazon-ebs" "Filebeat-web-server" {
  ami_name              = "${var.filebeat_ami_name}-${local.timestamp}"
  instance_type         = "t2.micro"
  region                = "eu-west-1"
  vpc_id                = "vpc-0c5401cf49bc67425"
  subnet_id             = "subnet-049472b14fea66156" //public subnet
  security_group_id     = "sg-00bd3b3247f5f8294" //packer sg or open sg
  deprecate_at          = timeadd(timestamp(), "8766h")
  force_deregister      = "true"
  force_delete_snapshot = "true"

  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

#Build for Elasticsearch
build {
  name = "elasticsearch-build"
  sources = [
    "source.amazon-ebs.Elasticsearch-web-server"
  ]
}

#Build for Kibana
build {
  name = "kibana-build"
  sources = [
    "source.amazon-ebs.Kibana-web-server"
  ]
}

#Build for Logstash
build {
  name = "logstash-build"
  sources = [
    "source.amazon-ebs.Logstash-web-server"
  ]
}

#Build for Filebeat
build {
  name = "filebeat-build"
  sources = [
    "source.amazon-ebs.Filebeat-web-server"
  ]
}