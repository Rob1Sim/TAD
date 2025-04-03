-- ============================
-- TEST : FULL JOIN SUR MAX DE TABLES
-- Objectif : exécuter une requête qui traverse un maximum de tables
-- pour mesurer le temps d'exécution global avec ou sans optimisation
-- ============================

SET TIMING ON;

-- Nettoyage de PLAN_TABLE
DROP TABLE PLAN_TABLE PURGE;
CREATE TABLE PLAN_TABLE AS SELECT * FROM SYS.PLAN_TABLE$;

-- EXPLAIN PLAN pour la requête complète
EXPLAIN PLAN SET STATEMENT_ID = 'full_join_perf' FOR
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

-- Affichage du plan d'exécution
SELECT STATEMENT_ID, OPERATION, OPTIONS, OBJECT_NAME, ID, PARENT_ID
FROM PLAN_TABLE
WHERE STATEMENT_ID = 'full_join_perf';

-- Exécution réelle de la requête
SET AUTOTRACE ON STATISTICS;
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
SET AUTOTRACE OFF;
