-- Role
-- Les tables doivent être créées avant de créer les rôles
alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE Admin;
CREATE ROLE Network_technician;
CREATE ROLE Machine_technician;
CREATE ROLE Accountant;
CREATE ROLE Technical_manager;
CREATE ROLE Project_manager;
CREATE ROLE Client;

GRANT DBA to Admin;

