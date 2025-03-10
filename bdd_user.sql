
CREATE ROLE Administrator;
GRANT DBA to Administrator;

CREATE ROLE Technicien_Reseau;
GRANT UPDATE, DELETE, INSERT, SELECT ON Network to Technicien_Reseau;

CREATE ROLE Technicien_Machine;
GRANT UPDATE, DELETE, INSERT, SELECT ON Device TO Technicien_Machine;
GRANT UPDATE, DELETE, INSERT, SELECT ON Peripheral TO Technicien_Machine;
GRANT UPDATE, DELETE, INSERT, SELECT ON VM TO Technicien_Machine;
GRANT UPDATE, DELETE, INSERT, SELECT ON License_Device TO Technicien_Machine;

CREATE ROLE Manager;
GRANT INSERT ON Device TO Manager;
GRANT INSERT ON Peripheral TO Manager;
GRANT INSERT ON VM TO Manager;
GRANT INSERT ON License_Device TO Manager;

CREATE ROLE Compta;
GRANT SELECT ON Prix_Device TO Compta;
GRANT SELECT ON Prix_Peripheral TO Compta;
GRANT SELECT ON Prix_Licences TO Compta;
GRANT SELECT ON Prix_Intervention TO Compta;

CREATE ROLE Gestionnaire;
GRANT UPDATE, DELETE, INSERT, SELECT ON Ticket TO Gestionnaire;
GRANT UPDATE, DELETE, INSERT, SELECT ON Projet TO Gestionnaire;
GRANT UPDATE, DELETE, INSERT, SELECT ON Intervention TO Gestionnaire;

CREATE ROLE Role_Intervention;
GRANT UPDATE ON Intervention TO Role_Intervention;

CREATE ROLE Lambda;
GRANT INSERT ON Ticket TO Lambda;
GRANT SELECT TO Lambda;


CREATE USER Admin;
GRANT Adminimistrator to Admin;

CREATE USER Network_Tech;
GRANT Technicien_Reseau, Intervention, Lambda TO Network_Tech;

CREATE USER Machine_Tech;
GRANT Technicien_Machine, Intervention, Lambda TO Machine_Tech;

CREATE USER Tech;
GRANT Technicien_Machine, Technicien_Reseau, Intervention, Lamba, TO Tech;

CREATE USER Manager;
GRANT Gestionnaire, Lamba TO Manager;

CREATE USER Comptable;
GRANT Compta TO Comptable;