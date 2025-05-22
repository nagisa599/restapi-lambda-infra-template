resource "aws_subnet" "public" {
  for_each                = tomap({ for idx, cidr in var.public_subnet_cidr_blocks : idx => cidr })
  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = element(var.availability_zones, tonumber(each.key))
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.project_name}-${var.env}-public-subnet-${each.key}"
    },
    var.tags
  )
}

# resource "aws_subnet" "private" {
#   for_each          = tomap({ for idx, cidr in var.private_subnet_cidr_blocks : idx => cidr })
#   vpc_id            = var.vpc_id
#   cidr_block        = each.value
#   availability_zone = element(var.availability_zones, tonumber(each.key))

#   tags = merge(
#     {
#       Name = "${var.project_name}-${var.env}-private-subnet-${each.key}"
#     },
#     var.tags
#   )
# }

# --------------------------------------------
# Internet Gateway
# --------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project_name}-${var.env}-igw"
    project_name = var.project_name
    env         = var.env
  }
}
# ----------------------------------------------
# Elastic IP
# ----------------------------------------------
# resource "aws_eip" "nat" {
#   tags = {
#     Name = "${var.project_name}-${var.env}-nat-eip"
#   }
# }

# -----------------------------------------------
# NAT Gateway
# -----------------------------------------------
# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public["0"].id

#   tags = {
#     Name = "${var.project_name}-${var.env}-nat-gateway"
#   }
# }

# --------------------------------------------
# Route Table module (table)
# --------------------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  tags = merge(
    {
      Name = "${var.project_name}-${var.env}-public-rt"
    },
    var.tags
  )
}




resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on             = [aws_internet_gateway.main]
}

# resource "aws_route" "private_nat_gateway_route" {
#   for_each               = aws_nat_gateway.main
#   route_table_id         = aws_route_table.public_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.main.id
#   depends_on             = [aws_nat_gateway.main]
# }

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public["0"].id
  route_table_id = aws_route_table.public_route_table.id
}

# resource "aws_route_table_association" "private_route_table_association" {
#   for_each       = aws_subnet.private
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_route_table[each.key].id
# }