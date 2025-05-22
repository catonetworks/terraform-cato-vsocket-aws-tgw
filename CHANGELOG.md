# Changelog

## 0.0.1 (2025-05-19)

### Features
- Initial commit with single socket instance with 3 NICs, creating full vpc
- Uses Separate Subnet for TGW Endpoints

## 0.0.2 (2025-05-22)

### Features 
- Changed Referenced Var route_table_id = module.cato_deployment.lan_route_table_id to route_table_id = module.cato_deployment.lan_subnet_route_table_id