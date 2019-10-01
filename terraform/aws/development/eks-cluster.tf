# Resource configuration for AWS' EKS service

# Creating iam role with policy that allows access to eks.
resource "aws_iam_role" "moonrake-demo-cluster" {
  name = "moonrake-eks-demo-cluster"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

# Attatching AmazonEKSClusterPolicy to moonrake-eks-demo-cluster
resource "aws_iam_role_policy_attachment" "moonrake-demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.moonrake-demo-cluster.name}"
}
# Attatching AmazonEKSServicePolicy to moonrake-eks-demo-cluster
resource "aws_iam_role_policy_attachment" "moonrake-demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.moonrake-demo-cluster.name}"
}

# Creating AWS Security Group to moonrake-eks-demo-cluster
resource "aws_security_group" "moonrake-demo-cluster" {
  name = "${aws_iam_role.moonrake-demo-cluster.name}"
  description = "Allows cluster connectivity to worker nodes."
  vpc_id = "${aws_vpc.moonrake_demo.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
      "Name", "${var.cluster-name}-sg",
      "Company", "Moonrake",
      "Environment", "${var.environment}",
    )
  }"
}

# Creating AWS Security Group to allow HTTPS communication over port 443
resource "aws_security_group" "moonrake-demo-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.moonrake-demo-cluster.id}"
  source_security_group_id = "${aws_security_group.moonrake-demo-node.id}" # NOTE: Name node sg moonrake-demo-node.
  to_port                  = 443
  type                     = "ingress"

  tags = "${
    map(
      "Name", "${var.cluster-name}-sg",
      "Company", "Moonrake",
      "Environment", "${var.environment}",
    )
  }"
}

# Creating
