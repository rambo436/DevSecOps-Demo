# Configuring AWS VPC Resources

# Adding VPC
resource "aws_vpc" "moonrake_demo" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "moonrake-eks-demo-vpc",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

# Adding Subnets to VPC
resource "aws_subnet" "moonrake_demo" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.demo.id}"

  tags = "${
    map(
      "Name", "moonrake-eks-demo-subnet",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

# Adding AWS Internet Gateway to VPC
resource "aws_internet_gateway" "moonrake_demo" {
  vpc_id = "${aws_vpc.moonrake_demo.id}"

  tags = {
    Name = "moonrake-eks-demo-ig"
  }
}
