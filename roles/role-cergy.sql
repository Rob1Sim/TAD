@role-all.sql
-- Users
-- (is that a jojo reference?)
 -- Cergy
CREATE USER admin_speedwagon IDENTIFIED BY password;
CREATE USER network_technician_jonhatan IDENTIFIED BY password;
CREATE USER machine_technician_dio IDENTIFIED BY password;
CREATE USER accountant_jolyne IDENTIFIED BY password;
CREATE USER technical_manager_jotaro IDENTIFIED BY password;
CREATE USER project_manager_jean_pierre IDENTIFIED BY password;
CREATE USER client_iggy IDENTIFIED BY password;
CREATE USER client_okuyasu IDENTIFIED BY password;
CREATE USER client_johnny IDENTIFIED BY password;

CREATE USER network_technician_cesar IDENTIFIED BY password;
CREATE USER machine_technician_kira IDENTIFIED BY password;
CREATE USER machine_technician_kars IDENTIFIED BY password;


-- Roles de connexions 

GRANT CONNECT TO admin_speedwagon;
GRANT CONNECT TO network_technician_jonhatan;
GRANT CONNECT TO machine_technician_dio;
GRANT CONNECT TO accountant_jolyne;
GRANT CONNECT TO technical_manager_jotaro;
GRANT CONNECT TO project_manager_jean_pierre;
GRANT CONNECT TO client_iggy;
GRANT CONNECT TO client_okuyasu;
GRANT CONNECT TO client_johnny;
GRANT CONNECT TO network_technician_cesar;
GRANT CONNECT TO machine_technician_kars;
GRANT CONNECT TO machine_technician_kira;

-- Permissions sur les users
GRANT Admin to admin_speedwagon;

GRANT Network_technician, Client TO network_technician_jonhatan;

GRANT Machine_technician, Client TO machine_technician_dio;

GRANT Machine_technician, Network_technician, Technical_manager, Client TO technical_manager_jotaro;

GRANT Project_manager, Client TO project_manager_jean_pierre;

GRANT Accountant TO accountant_jolyne;

