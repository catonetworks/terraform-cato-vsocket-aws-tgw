output "aws_ec2_transit_gateway_vpc_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment connecting the Cato VPC to the TGW"
  value       = aws_ec2_transit_gateway_vpc_attachment.cato_vpc.id
}

output "aws_ec2_transit_gateway_vpc_attachment_tgwid" {
  description = "Transit Gateway ID associated with the VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.cato_vpc.transit_gateway_id
}

output "cato_module_output" {
  description = "Complete output map from the referenced Cato deployment module"
  value       = module.cato_deployment
}