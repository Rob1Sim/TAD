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
