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
