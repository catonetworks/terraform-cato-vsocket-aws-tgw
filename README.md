# CATO VSOCKET AWS Transit Gateway Terraform module

Terraform module which creates a VPC, required subnets, elastic network interfaces, security groups, route tables, an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.  Then attaches the deployment to a transit gateway and specifies a default route to send traffic to the virtual socket ec2 instance.

For the vpc_id and internet_gateway_id leave null to create new or add an id of the already created resources to use existing.

Requires an aws transit gateway ID (tgw_id) and transit gateway route table ID (tgw_route_table_id) to connect with.

<details>
<summary>Example AWS VPC and Internet Gateway Resources</summary>

Create the AWS VPC and Internet Gateway resources using the following example, and create these resources first before running the module:

```hcl
resource "aws_vpc" "cato-vpc" {
  cidr_block = var.vpc_range
  tags = {
    Name = "${var.site_name}-VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "${var.site_name}-IGW"
  }
  vpc_id = aws_vpc.cato-vpc.id
}

terraform apply -target=aws_vpc.cato-vpc -target=aws_internet_gateway.internet_gateway
```

Reference the resources as input variables with the following syntax:
```hcl
  vpc_id           = aws_vpc.cato-vpc.id
  internetGateway  = aws_internet_gateway.internet_gateway.id 
```

</details>

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
// Initialize Providers
variable "region" {
  default = "us-west-2"
}

variable "baseurl" {}
variable "cato_token" {}
variable "account_id" {}


provider "aws" {
  region = var.region
}

provider "cato" {
  baseurl    = var.baseurl
  token      = var.cato_token
  account_id = var.account_id
}

// AWS VPC and Virtual Socket Module
module "vsocket-aws-vpc-tgw" {
  source                = "catonetworks/vsocket-aws-tgw/cato"
  vpc_id                = null
  internet_gateway_id   = null 
  ingress_cidr_blocks   = ["0.0.0.0/0"]
  key_pair              = "Your-Keypair-here"
  vpc_network_range     = "10.1.0.0/22"
  native_network_range  = "10.1.0.0/16"
  subnet_range_mgmt     = "10.1.1.0/25"
  subnet_range_wan      = "10.1.1.128/25"
  subnet_range_lan      = "10.1.2.0/25"
  subnet_range_tgw      = "10.1.2.128/25"
  mgmt_eni_ip           = "10.1.1.5"
  wan_eni_ip            = "10.1.1.135"
  lan_eni_ip            = "10.1.2.5"
  site_name             = "Your-Cato-site-name-here"
  tgw_id                = "tgw-01234567890abcdef"
  tgw_route_table_id    = "tgw-rtb-01234567890abcdef"
  site_description      = "Your Cato site desc here"
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
  }
  tags = {
    Environment = "Production"
    Owner = "Operations Team"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | ~> 0.0.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cato_deployment"></a> [cato\_deployment](#module\_cato\_deployment) | catonetworks/vsocket-aws-vpc/cato | ~> 0.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.all-zeros-cato](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.cato_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.cato_private_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table_association.lan_subnet_route_table_association_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.transit_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_ec2_transit_gateway.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | Set CIDR to receive traffic from the specified IPv4 CIDR address ranges<br/>	For example x.x.x.x/32 to allow one specific IP address access, 0.0.0.0/0 to allow all IP addresses access, or another CIDR range<br/>    Best practice is to allow a few IPs as possible<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `list(any)` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the vSocket | `string` | `"c5.xlarge"` | no |
| <a name="input_internet_gateway_id"></a> [internet\_gateway\_id](#input\_internet\_gateway\_id) | Specify an Internet Gateway ID to use. If not specified, a new Internet Gateway will be created. | `string` | `null` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Name of an existing Key Pair for AWS encryption | `string` | n/a | yes |
| <a name="input_lan_eni_ip"></a> [lan\_eni\_ip](#input\_lan\_eni\_ip) | Choose an IP Address within the LAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_mgmt_eni_ip"></a> [mgmt\_eni\_ip](#input\_mgmt\_eni\_ip) | Choose an IP Address within the Management Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Choose a unique range for your new vsocket site that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the vsocket site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the vsocket site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_subnet_range_lan"></a> [subnet\_range\_lan](#input\_subnet\_range\_lan) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_mgmt"></a> [subnet\_range\_mgmt](#input\_subnet\_range\_mgmt) | Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_tgw"></a> [subnet\_range\_tgw](#input\_subnet\_range\_tgw) | Choose a range within the VPC to use as the Transit Gateway subnet. This subnet will host the TransitGateway Endpoints.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_wan"></a> [subnet\_range\_wan](#input\_subnet\_range\_wan) | Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to AWS resources | `map(string)` | `{}` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | Specify the Transit Gateway ID to use.  We will attach a new VPC to this transit gateway with a vSocket in it, and set the default (0.0.0.0/0) route to point at this new VPC. | `string` | n/a | yes |
| <a name="input_tgw_route_table_id"></a> [tgw\_route\_table\_id](#input\_tgw\_route\_table\_id) | Specify the Transit Gateway Route Table to use.  This is where the 0.0.0.0/0 route will be set. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specify a VPC ID to use. If not specified, a new VPC will be created. | `string` | `null` | no |
| <a name="input_vpc_network_range"></a> [vpc\_network\_range](#input\_vpc\_network\_range) | Choose a unique range for your new vpc where the vSocket will live.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_wan_eni_ip"></a> [wan\_eni\_ip](#input\_wan\_eni\_ip) | Choose an IP Address within the Public/WAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ec2_transit_gateway_vpc_attachment_id"></a> [aws\_ec2\_transit\_gateway\_vpc\_attachment\_id](#output\_aws\_ec2\_transit\_gateway\_vpc\_attachment\_id) | ID of the Transit Gateway VPC attachment connecting the Cato VPC to the TGW |
| <a name="output_aws_ec2_transit_gateway_vpc_attachment_tgwid"></a> [aws\_ec2\_transit\_gateway\_vpc\_attachment\_tgwid](#output\_aws\_ec2\_transit\_gateway\_vpc\_attachment\_tgwid) | Transit Gateway ID associated with the VPC attachment |
| <a name="output_cato_module_output"></a> [cato\_module\_output](#output\_cato\_module\_output) | Complete output map from the referenced Cato deployment module |
<!-- END_TF_DOCS -->