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

## 0.0.5 (2025-06-27)

### Features 
- Added Site_Location, Site location is now derived from AWS Region 
- Added Routed Networks - Routed Networks can now be provided and auto routed to the TGW. 
- Updated Variables for New Features and to simplify the code 
- Removed native_network_range, this is now derived from subnet_range_lan 
- Updated Readme
- Cleaned up and reorganized code 
- Implemented Version constraints on modules and providers

## 0.0.6 (2025-08-1)

### Features
 - Updated to use latest provider version 
  - Adjusted routed_networks call to include interface_index 
 - Version Lock to Provider version 0.0.38 or greater