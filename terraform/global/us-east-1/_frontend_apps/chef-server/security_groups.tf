module "common-vpc" {
  source = "git::ssh://git@github.com/TheWeatherCompany/grid-env-modules.git//terraform/common-vpc"
}

resource "aws_security_group" "chef-client" {
  name        = "${var.PROJECT}-chef-server-sg"
  description = "Allows port 443 web traffic, all internal traffic and all outbound traffic"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  # allow TCP port 443 for web traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow TCP port 22 for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",",module.common-vpc.twc_cidr_blocks_offices)}","${var.additional_ips}"]
  }

  # allow all TCP internal traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${element(data.terraform_remote_state.vpc.vpc_public_subnet_cidrs,1)}"]
  }

  # allow all TCP egress
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
