DROP DATABASE LINK PAU;

CREATE DATABASE LINK PAU
CONNECT TO admin_giorno IDENTIFIED BY "password"
USING 'pau:1521/FREE';

DROP DATABASE LINK CERGY;

CREATE DATABASE LINK CERGY
CONNECT TO admin_speedwagon IDENTIFIED BY "password"
USING 'cergy:1521/FREE';

-- logs pour les materialized views
CREATE MATERIALIZED VIEW LOG ON PERMISSIONS
WITH PRIMARY KEY
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON GROUPS
WITH PRIMARY KEY
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON USER_GROUP_PERMISSIONS
WITH PRIMARY KEY
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON USER_GROUP
WITH PRIMARY KEY
INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON LICENCE_DEVICE
WITH PRIMARY KEY
INCLUDING NEW VALUES;


DROP MATERIALIZED VIEW MV_PERMISSIONS;
DROP MATERIALIZED VIEW MV_GROUPS;
DROP MATERIALIZED VIEW MV_USER_GROUP_PERMISSIONS;
DROP MATERIALIZED VIEW MV_USER_GROUP;
DROP MATERIALIZED VIEW MV_LICENCE_DEVICE;


-- Vues matérialisées sur Pau
-- On part du principe que les données ne sont pas critique et que l'on peut se permettre de faire des copies
-- identité
CREATE MATERIALIZED VIEW MV_PERMISSIONS
REFRESH FAST 
AS SELECT * FROM PERMISSIONS@CERGY;

CREATE MATERIALIZED VIEW MV_GROUPS
REFRESH FAST 
AS SELECT * FROM GROUPS@CERGY;

CREATE MATERIALIZED VIEW MV_USER_GROUP_PERMISSIONS
REFRESH FAST 
AS SELECT * FROM USER_GROUP_PERMISSIONS@CERGY;

CREATE MATERIALIZED VIEW MV_USER_GROUP
REFRESH FAST 
AS SELECT * FROM USER_GROUP@CERGY;

-- Infra

CREATE MATERIALIZED VIEW MV_LICENCE_DEVICE
REFRESH FAST 
AS SELECT * FROM LICENCE_DEVICE@CERGY;



-- Fragmentation horizontale


CREATE VIEW V_ALL_USERS 
AS SELECT * FROM GLPI_USER@CERGY
UNION
SELECT * FROM GLPI_USER@PAU;

CREATE VIEW V_ALL_LISCENCE_DEVICE
AS SELECT * FROM LICENCE_DEVICE@CERGY
UNION
SELECT * FROM MV_LICENCE_DEVICE@PAU;

