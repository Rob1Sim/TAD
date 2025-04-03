-- =======================
-- TEST 1 : SANS INDEX NI CLUSTER (avec PLAN_TABLE manuelle)
-- =======================

-- Ce script utilise une définition manuelle de la table PLAN_TABLE comme fournie par l'utilisateur
-- Attention : le type LONG de la colonne OTHER peut limiter certaines fonctionnalités avancées

-- Création de la table PLAN_TABLE (si non encore créée)
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE PLAN_TABLE (
    STATEMENT_ID VARCHAR2 (30),
    TIMESTAMP DATE,
    REMARKS VARCHAR2 (80),
    OPERATION VARCHAR2 (30),
    OPTIONS VARCHAR2 (30),
    OBJECT_NODE VARCHAR2 (30),
    OBJECT_OWNER VARCHAR2 (30),
    OBJECT_NAME VARCHAR2 (30),
    OBJECT_INSTANCE NUMBER (38),
    OBJECT_TYPE VARCHAR2 (30),
    SEARCH_COLUMNS NUMBER (38),
    ID NUMBER (38),
    PARENT_ID NUMBER (38),
    POSITION NUMBER (38),
    OTHER LONG
  )';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -955 THEN -- -955 = table already exists
      RAISE;
    END IF;
END;
/

-- Activation du chronomètre Oracle
SET TIMING ON;

-- Génération du plan d'exécution
EXPLAIN PLAN SET STATEMENT_ID = 'no_index_cluster' FOR
SELECT d.id, p.description
FROM DEVICE d
JOIN PERIPHERAL p ON d.id = p.id_device
WHERE p.type = 'clavier';

-- Affichage manuel du plan
PROMPT ===== PLAN D'EXECUTION DE LA REQUETE =====
SELECT STATEMENT_ID, OPERATION, OPTIONS, OBJECT_NAME, ID, PARENT_ID
FROM PLAN_TABLE
WHERE STATEMENT_ID = 'no_index_cluster';

-- MESURE DU TEMPS D'EXECUTION REEL
SET AUTOTRACE ON STATISTICS;
SELECT d.id, p.description
FROM DEVICE d
JOIN PERIPHERAL p ON d.id = p.id_device
WHERE p.type = 'clavier';
SET AUTOTRACE OFF;

SELECT * FROM PLAN_TABLE
ORDER BY TIMESTAMP DESC;
