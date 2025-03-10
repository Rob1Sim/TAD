-- Role
alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE Admin;
CREATE ROLE Network_technician;
CREATE ROLE Machine_technician;
CREATE ROLE Accountant;
CREATE ROLE Technical_manager;
CREATE ROLE Project_manager;
CREATE ROLE Client;

-- Users
-- (is that a jojo reference?)
-- Admin
CREATE USER admin_giorno IDENTIFIED BY password;
CREATE USER admin_speedwagon IDENTIFIED BY password;

-- Network_technician
CREATE USER network_technician_jonhatan IDENTIFIED BY password;
CREATE USER network_technician_joseph IDENTIFIED BY password;
CREATE USER network_technician_cesar IDENTIFIED BY password;
CREATE USER network_technician_lisa_lisa IDENTIFIED BY password;

-- Machine_technician
CREATE USER machine_technician_dio IDENTIFIED BY password;
CREATE USER machine_technician_pucci IDENTIFIED BY password;
CREATE USER machine_technician_kira IDENTIFIED BY password;
CREATE USER machine_technician_diavolo IDENTIFIED BY password;
CREATE USER machine_technician_kars IDENTIFIED BY password;

-- Accountant
CREATE USER accountant_jolyne IDENTIFIED BY password;
CREATE USER accountant_kakyoin IDENTIFIED BY password;

-- Technical_manager
CREATE USER technical_manager_jotaro IDENTIFIED BY password;
CREATE USER technical_manager_smokey IDENTIFIED BY password;

-- Project_manager
CREATE USER project_manager_josuke IDENTIFIED BY password;
CREATE USER project_manager_jean_pierre IDENTIFIED BY password;

-- Client
CREATE USER client_iggy IDENTIFIED BY password;
CREATE USER client_okuyasu IDENTIFIED BY password;
CREATE USER client_johnny IDENTIFIED BY password;

-- Roles de connexions 
GRANT CONNECT TO admin_giorno;
GRANT CONNECT TO admin_speedwagon;
GRANT CONNECT TO network_technician_jonhatan;
GRANT CONNECT TO network_technician_joseph;
GRANT CONNECT TO network_technician_cesar;
GRANT CONNECT TO network_technician_lisa_lisa;
GRANT CONNECT TO machine_technician_dio;
GRANT CONNECT TO machine_technician_pucci;
GRANT CONNECT TO machine_technician_kira;
GRANT CONNECT TO machine_technician_diavolo;
GRANT CONNECT TO machine_technician_kars;
GRANT CONNECT TO accountant_jolyne;
GRANT CONNECT TO accountant_kakyoin;
GRANT CONNECT TO technical_manager_jotaro;
GRANT CONNECT TO technical_manager_smokey;
GRANT CONNECT TO project_manager_josuke;
GRANT CONNECT TO project_manager_jean_pierre;
GRANT CONNECT TO client_iggy;
GRANT CONNECT TO client_okuyasu;
GRANT CONNECT TO client_johnny;

-- Permissions
GRANT DBA to Admin;

GRANT UPDATE, DELETE, INSERT, SELECT ON NETWORK to Network_technician;

GRANT UPDATE, DELETE, INSERT, SELECT ON DEVICE TO Machine_technician;
GRANT UPDATE, DELETE, INSERT, SELECT ON PERIPHERAL TO Machine_technician;
GRANT UPDATE, DELETE, INSERT, SELECT ON VM TO Machine_technician;
GRANT UPDATE, DELETE, INSERT, SELECT ON LICENCE_DEVICE TO Machine_technician;

GRANT INSERT ON DEVICE TO Technical_manager;
GRANT INSERT ON PERIPHERAL TO Technical_manager;
GRANT INSERT ON VM TO Technical_manager;
GRANT INSERT ON LICENCE_DEVICE TO Technical_manager;

-- Permissions sur les vues (à tester)
GRANT SELECT ON Prix_Device TO Accountant;
GRANT SELECT ON Prix_Peripheral TO Accountant;
GRANT SELECT ON Prix_Licences TO Accountant;
GRANT SELECT ON Prix_Intervention TO Accountant;

GRANT UPDATE, DELETE, INSERT, SELECT ON TICKET TO Project_manager;
GRANT UPDATE, DELETE, INSERT, SELECT ON PROJECT TO Project_manager;
GRANT UPDATE, DELETE, INSERT, SELECT ON INTERVENTION TO Project_manager;

GRANT UPDATE ON INTERVENTION TO Technical_manager;

GRANT INSERT ON TICKET TO Client;

GRANT SELECT ON PERIPHERAL TO Client;
GRANT SELECT ON DEVICE TO Client;
GRANT SELECT ON VM TO Client;
GRANT SELECT ON LICENCE_DEVICE TO Client;


-- Permissions sur les users
GRANT Admin to admin_giorno;

GRANT Network_technician, Client TO network_technician_jonhatan;

GRANT Machine_technician, Client TO machine_technician_dio;

GRANT Machine_technician, Network_technician, Technical_manager, Client TO technical_manager_jotaro;

GRANT Project_manager, Client TO project_manager_jean_pierre;

GRANT Accountant TO accountant_jolyne;