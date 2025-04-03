DROP DATABASE LINK PAU;

CREATE DATABASE LINK PAU
CONNECT TO admin_giorno IDENTIFIED BY "password"
USING 'pau:1521/FREE';

DROP DATABASE LINK CERGY;

CREATE DATABASE LINK CERGY
CONNECT TO admin_speedwagon IDENTIFIED BY "password"
USING 'cergy:1521/FREE';


-- Fragmentation horizontale

CREATE VIEW V_ALL_USERS 
AS SELECT * FROM GLPI_USER@CERGY
UNION
SELECT * FROM GLPI_USER@PAU;

CREATE VIEW V_ALL_LICENCE_DEVICE
AS SELECT * FROM LICENCE_DEVICE@CERGY
UNION
SELECT * FROM MV_LICENCE_DEVICE@PAU;

COMMIT;