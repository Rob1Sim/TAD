-- Cergy container 
--docker run -d --name cergy --network oracle-net -p 1522:1521 -e ORACLE_PASSWORD=password -v oracle-volume-cergy:/opt/oracle/oradata gvenzl/oracle-free
--docker run -d --name pau --network oracle-net -p 1523:1521 -e ORACLE_PASSWORD=password -v oracle-volume-pau:/opt/oracle/oradata gvenzl/oracle-free

CREATE DATABASE LINK PAU
CONNECT TO SYSTEM IDENTIFIED BY "password"
USING 'pau:1521/FREE';

CREATE DATABASE LINK CERGY
CONNECT TO SYSTEM IDENTIFIED BY "password"
USING 'cergy:1521/FREE';


--  a cacher
ALTER TABLE USER_GROUP DROP CONSTRAINT SYS_C008802;
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'USER_GROUP';

-- iteration better_data_cy

@../plsql/better_data_cergy.sql


--Robin fragmentation

-- Dans Cergy
INSERT INTO GROUPS (id, name) VALUES (10, 'Comptabilité');

INSERT INTO USER_GLPI (id, last_name, first_name) VALUES (100, 'Martinez','David');
INSERT INTO USER_GROUP (id_user, id_group) VALUES (100, 10);

-- on a un groupe compta avec un comptable

-- On veut ajouté un comptable de pau
-- On imagine que ce user est a pau
INSERT INTO USER_GLPI (id, last_name, first_name) VALUES (101, 'Kushina','Lucy');

-- A cergy
INSERT INTO USER_GROUP (id_user, id_group) VALUES (101, 10);

-- Si on veut récup les users comptable
SELECT J.last_name, J.first_name
FROM V_ALL_USERS J JOIN USER_GROUP UG ON J.id = UG.id_user;

--appel la fonction is_date_valide 


--Connect role client_johnny pour montrer qu'on peut rien faire
SELECT * FROM SYSTEM.DEVICE ;

SELECT * FROM SYSTEM.TICKET ;
-- La grosse requête

SELECT
    u.first_name || ' ' || u.last_name AS utilisateur,
    t.subject AS sujet_ticket,
    i.description AS intervention,
    d.description AS appareil,
    p.description AS peripherique,
    v.description AS vm,
    l.expiration_date AS date_licence,
    n.name AS nom_reseau,
    pr.name AS nom_projet,
    g.name AS groupe
FROM GLPI_USER u
JOIN AFFECTATION a ON a.id_user = u.id
JOIN INTERVENTION i ON a.id_intervention = i.id
JOIN DEVICE d ON d.id = i.id_device
LEFT JOIN PERIPHERAL p ON p.id_device = d.id
LEFT JOIN VM v ON v.id_device = d.id
LEFT JOIN LICENCE_DEVICE l ON l.id_device = d.id
LEFT JOIN NETWORK n ON n.id = d.id_network
JOIN TICKET t ON t.id = a.id_ticket
LEFT JOIN PROJECT pr ON pr.id = t.id_project
LEFT JOIN USER_GROUP ug ON ug.id_user = u.id
LEFT JOIN GROUPS g ON g.id = ug.id_group;

-- David 


-- Analysons ce ticket
SELECT * FROM Ticket WHERE id = 1 ; 

SELECT * from  PROJECT WHERE id = 1;
 
-- 2. Affecter le ticket
SELECT * FROM AFFECTATION
WHERE id_ticket = 2;

--Trouver une intervention
SELECT * FROM INTERVENTION;
 
-- 3. Afficher les infos de la machine
exec get_all_info_device(1);
SELECT SETUP_PRICE(1) FROM DUAL;


-- 5. Toute les interventions sont terminées
UPDATE INTERVENTION i
SET type = 'CLOTUREE'
WHERE i.id IN (
    SELECT a.id_intervention
    FROM AFFECTATION a
    WHERE a.id_ticket = 3
);


-- Reouverture d'un ticket
INSERT INTO INTERVENTION (id, inter_date, price, description, type, id_device)
        VALUES (101, SYSDATE , 250, 'Intervention for Device ' || 1, 'Maintenance', 1);
                -- Associer une intervention à un ticket de manière aléatoire
    INSERT INTO AFFECTATION (id, date_affectation, id_user, id_intervention, id_ticket)
        VALUES (101, SYSDATE, 1, 101, 2);



SELECT * FROM PROJECT WHERE id = 2;

SELECT * FROM INTERVENTION  Where id = 101;


