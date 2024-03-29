# Resource configuration for AWS EKS Nodes

# Creating iam role to append policies to.
resource "aws_iam_role" "moonrake-demo-node" {
  name = "moonrake-eks-demo-node"

  assume_role_policy = <<POLICY
  {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
   ]
  }
POLICY
}

# Attatching AmazonEKSClusterPolicy to moonrake-eks-demo-node
resource "aws_iam_role_policy_attachment" "moonrake-demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.moonrake-demo-node.name}"
}

# Attatching AmazonEKSServicePolicy to moonrake-eks-demo-node
resource "aws_iam_role_policy_attachment" "moonrake-demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.moonrake-demo-node.name}"
}

# Attatching AmazonEC2ContainerRegistryReadOnly policy to moonrake-eks-demo-node
resource "aws_iam_role_policy_attachment" "moonrake-demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.moonrake-demo-node.name}"
}

# Providing an AWS IAM instance profile
resource "aws_iam_instance_profile" "moonrake-demo-node" {
  name = "moonrake-eks-demo-node"
  role = "${aws_iam_role.moonrake-demo-node.name}"
}

# Creating AWS Security Group to moonrake-eks-demo-node
resource "aws_security_group" "moonrake-demo-node" {
  name        = "moonrake-eks-demo-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.moonrake_demo.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
      "Name", "moonrake-eks-demo-node-sg",
      "Company", "Moonrake",
      "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

# Appending aws security group rule to allow inter-node communication.
resource "aws_security_group_rule" "moonrake-demo-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.moonrake-demo-node.id}"
  source_security_group_id = "${aws_security_group.moonrake-demo-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

# Appending sg rule to allow the kubelets and pods to receive commands from the CCP.
resource "aws_security_group_rule" "moonrake-demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.moonrake-demo-node.id}"
  source_security_group_id = "${aws_security_group.moonrake-demo-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

data "aws_ami" "moonrake-eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.moonrake_demo.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # TODO: Get Amazon EKS AMI Account ID (might be 602401143452)
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  moonrake-demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.moonrake_demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.moonrake_demo.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

# Configuring launch configuration.
resource "aws_launch_configuration" "moonrake_demo" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.moonrake-demo-node.name}"
  image_id                    = "${data.aws_ami.moonrake-eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "moonrake-eks-demo"
  security_groups             = ["${aws_security_group.moonrake-demo-node.id}"]
  user_data_base64            = "${base64encode(local.moonrake-demo-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

# Creating autoscaling group
resource "aws_autoscaling_group" "moonrake_demo" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.moonrake_demo.id}"
  max_size             = 2
  min_size             = 1
  name                 = "moonrake-eks-demo"
  vpc_zone_identifier  = "${aws_subnet.moonrake_demo[*].id}"

  tag {
    key                 = "Company"
    value               = "Moonrake"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "moonrake-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
