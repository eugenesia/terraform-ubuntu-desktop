# Configure DigitalOcean provider.
provider aws {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-2"             # London
}

data aws_ami ubuntu {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Render userdata.sh with variables.
data template_file userdata {
  template = "${file("userdata.sh")}"

  vars {
    vnc_password = "${var.vnc_password}"
  }
}

resource aws_instance desktop {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.medium"
  user_data       = "${base64encode(data.template_file.userdata.rendered)}"
  key_name        = "Eug TM"
  security_groups = ["${aws_security_group.desktop.name}"]

  tags {
    Name = "desktop"
  }
}

# resource aws_launch_template desktop {
#   name          = "desktop"
#   description   = "Ubuntu desktop."
#   image_id      = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.medium"
#   user_data     = "${base64encode(data.template_file.userdata.rendered)}"
# 
#   # Elastic GPU only available for Windows AMIs.
#   # elastic_gpu_specifications {
#   #   type = "eg1.medium"
#   # }
# 
#   tag_specifications {
#     resource_type = "instance"
# 
#     tags {
#       Name = "desktop"
#     }
#   }
# }
# 
# resource aws_autoscaling_group desktop {
#   desired_capacity   = 1
#   max_size           = 1
#   min_size           = 1
#   availability_zones = ["eu-west-1a"]
# 
#   launch_template {
#     id      = "${aws_launch_template.desktop.id}"
#     version = "$$Latest"
#   }
# }

