# Configuring AWS VPC Resources

# Adding VPC
resource "aws_vpc" "moonrake_demo" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "moonrake-eks-demo-vpc",
      "Company", "Moonrake",
      "Environment", "${var.environment}",
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
      "Company", "Moonrake",
      "Environment", "${var.environment}",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

# Adding AWS Internet Gateway to VPC
resource "aws_internet_gateway" "moonrake_demo" {
  vpc_id = "${aws_vpc.moonrake_demo.id}"

  tags = "${
    map(
      "Name" = "moonrake-eks-demo-ig"
      "Company", "Moonrake",
      "Environment", "${var.environment}",
    )
  }"
}

resource "aws_route_table" "moonrake_demo" {
  count = 3
  subnet_id = "${aws_subnet.moonrake_demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.moonrake_demo.id}"

  tags = "${
    map(
      "Name" = "moonrake-eks-demo-rt"
      "Company", "Moonrake",
      "Environment", "${var.environment}",
    )
  }"
}
