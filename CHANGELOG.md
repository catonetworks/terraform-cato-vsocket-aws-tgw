# Changelog

## 0.0.1 (2025-05-19)

### Features
- Initial commit with single socket instance with 3 NICs, creating full vpc
- Uses Separate Subnet for TGW Endpoints

## 0.0.2 (2025-05-22)

### Features 
- Changed Referenced Var route_table_id = module.cato_deployment.lan_route_table_id to route_table_id = module.cato_deployment.lan_subnet_route_table_id
- Updated Ref from AZID to AZ
- Added Null Resource and Depends on to get the Subnet route to the TGW to create without error

## 0.0.3 (2025-05-30)

### Features
- Created Feature Flag for Default Route in TGW Creation to Enable Planned Migration. 

## 0.0.4 (2025-06-05)

## Features
- fixed typo found in Variables.tf 