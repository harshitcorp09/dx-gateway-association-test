provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

resource "aws_dx_gateway" "lnd_eng_1" {
  name            = "LDN_IXN_ENG_1"
  amazon_side_asn = "64512"
}

resource "aws_ec2_transit_gateway" "main_router" {
  description = "Main transit gateway"
}

resource "aws_ec2_transit_gateway_route_table" "main_router" {
  transit_gateway_id = aws_ec2_transit_gateway.main_router.id
}

resource "aws_dx_gateway_association" "lnd_eng_1" {
  dx_gateway_id         = aws_dx_gateway.lnd_eng_1.id
  associated_gateway_id = aws_ec2_transit_gateway.main_router.id
  allowed_prefixes      = local.dx_gateway_allowed_prefixes
}

resource "aws_ec2_transit_gateway_route_table_association" "dx_gateway_lnd_eng_1" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.lnd_eng_1.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.main_router.id
}

data "aws_ec2_transit_gateway_attachment" "lnd_eng_1" {
  transit_gateway_id = aws_ec2_transit_gateway.main_router.id
}

locals {
  dx_gateway_allowed_prefixes = ["10.0.0.0/16", "192.168.0.0/16"]
}

output "dx_gateway_id" {
  value = aws_dx_gateway.lnd_eng_1.id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main_router.id
}

output "transit_gateway_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.main_router.id
}

output "dx_gateway_association_id" {
  value = aws_dx_gateway_association.lnd_eng_1.id
}

output "transit_gateway_route_table_association_id" {
  value = aws_ec2_transit_gateway_route_table_association.dx_gateway_lnd_eng_1.id
}
