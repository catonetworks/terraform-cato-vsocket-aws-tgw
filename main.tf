module "cato_deployment" {
  source               = "catonetworks/vsocket-aws-vpc/cato"
  version              = "~> 0.0.9"
  vpc_id               = var.vpc_id
  ingress_cidr_blocks  = var.ingress_cidr_blocks
  key_pair             = var.key_pair
  subnet_range_mgmt    = var.subnet_range_mgmt
  subnet_range_wan     = var.subnet_range_wan
  subnet_range_lan     = var.subnet_range_lan
  mgmt_eni_ip          = var.mgmt_eni_ip
  wan_eni_ip           = var.wan_eni_ip
  lan_eni_ip           = var.lan_eni_ip
  vpc_network_range    = var.vpc_network_range
  native_network_range = var.native_network_range
  site_name            = var.site_name
  site_description     = var.site_description
  site_location        = var.site_location
  tags                 = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "cato_vpc" {
  vpc_id             = module.cato_deployment.vpc_id
  transit_gateway_id = var.tgw_id
  subnet_ids         = [aws_subnet.transit_gateway.id]
  tags = merge(var.tags, {
  Name = "${var.site_name}-TGW-Attachment" })
}

resource "aws_route" "cato_private_to_tgw" {
  route_table_id         = module.cato_deployment.lan_subnet_route_table_id
  destination_cidr_block = var.native_network_range
  transit_gateway_id     = var.tgw_id
}

resource "aws_ec2_transit_gateway_route" "all-zeros-cato" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.cato_vpc.id
  transit_gateway_route_table_id = var.tgw_route_table_id
}

resource "aws_subnet" "transit_gateway" {
  vpc_id               = var.vpc_id == null ? module.cato_deployment.vpc_id : var.vpc_id
  cidr_block           = var.subnet_range_tgw
  availability_zone = module.cato_deployment.lan_subnet_azid
  tags = merge(var.tags, {
  Name = "${var.site_name}-TGW-Subnet" })
}

resource "aws_route_table_association" "lan_subnet_route_table_association_primary" {
  subnet_id      = aws_subnet.transit_gateway.id
  route_table_id = module.cato_deployment.lan_subnet_route_table_id
}
