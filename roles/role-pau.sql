@role-all.sql

-- Role Pau
CREATE USER admin_giorno IDENTIFIED BY password;
CREATE USER network_technician_joseph IDENTIFIED BY password;
CREATE USER machine_technician_pucci IDENTIFIED BY password;
CREATE USER accountant_kakyoin IDENTIFIED BY password;
CREATE USER technical_manager_smokey IDENTIFIED BY password;
CREATE USER project_manager_josuke IDENTIFIED BY password;

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
GRANT CONNECT TO project_manager_josuke;


-- Permission au users
GRANT Admin to admin_giorno;

GRANT Network_technician, Client TO network_technician_joseph;

GRANT Machine_technician, Client TO machine_technician_pucci;

GRANT Machine_technician, Network_technician, Technical_manager, Client TO technical_manager_smokey;

GRANT Project_manager, Client TO project_manager_josuke;

GRANT Accountant TO accountant_kakyoin;