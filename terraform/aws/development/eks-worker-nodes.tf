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
  name = "moonrake-eks-demo"
  role = "${aws_iam_role.moonrake-demo-node.name}"
}
