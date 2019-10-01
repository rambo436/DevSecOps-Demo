# Configuring AWS VPC Resources

# Adding VPC
resource "aws_vpc" "moonrake-demo" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "moonrake-eks-demo",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

# Adding Subnets to VPC
resource "aws_subnet" "demo" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.demo.id}"

  tags = "${
    map(
      "Name", "terraform-eks-demo-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}
