@role-all.sql

-- Role Pau
CREATE USER admin_giorno IDENTIFIED BY password;
CREATE USER network_technician_joseph IDENTIFIED BY password;
CREATE USER machine_technician_pucci IDENTIFIED BY password;
CREATE USER accountant_kakyoin IDENTIFIED BY password;
CREATE USER technical_manager_smokey IDENTIFIED BY password;

CREATE USER network_technician_lisa_lisa IDENTIFIED BY password;
CREATE USER machine_technician_diavolo IDENTIFIED BY password;

-- Connect
GRANT CONNECT TO admin_giorno;
GRANT CONNECT TO network_technician_joseph;
GRANT CONNECT TO network_technician_lisa_lisa;
GRANT CONNECT TO machine_technician_pucci;
GRANT CONNECT TO machine_technician_diavolo;
GRANT CONNECT TO accountant_kakyoin;
GRANT CONNECT TO technical_manager_smokey;

-- Permission sur les Materialized Views
GRANT SELECT ON MV_PERMISSIONS TO Client;
GRANT SELECT ON MV_GROUPS TO Client;
GRANT SELECT ON MV_USER_GROUP_PERMISSIONS TO Client;
GRANT SELECT ON MV_USER_GROUP TO Client;
GRANT SELECT ON MV_LICENCE_DEVICE TO Client;

GRANT INSERT ON MV_LICENCE_DEVICE TO Technical_manager;

-- Permission au users
GRANT Admin to admin_giorno;

GRANT Network_technician, Client TO network_technician_joseph;

GRANT Machine_technician, Client TO machine_technician_pucci;

GRANT Machine_technician, Network_technician, Technical_manager, Client TO technical_manager_smokey;

GRANT Project_manager, Client TO project_manager_josuke;

GRANT Accountant TO accountant_kakyoin;