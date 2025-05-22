output "public_subnet_id" {
  value = aws_subnet.public["0"].id
  description = "The IDs of the public subnets"
}