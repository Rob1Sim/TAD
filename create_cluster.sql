DROP TABLE PERIPHERAL CASCADE CONSTRAINTS;
DROP TABLE VM CASCADE CONSTRAINTS;
DROP TABLE LICENCE_DEVICE CASCADE CONSTRAINTS;
DROP TABLE INTERVENTION CASCADE CONSTRAINTS;
DROP TABLE DEVICE CASCADE CONSTRAINTS;
DROP TABLE TICKET CASCADE CONSTRAINTS;
DROP TABLE GLPI_USER CASCADE CONSTRAINTS;
DROP TABLE AFFECTATION CASCADE CONSTRAINTS;

-- Cluster 1 : DEVICE et ses dépendants (PERIPHERAL, VM, LICENCE_DEVICE)
-- parce que toutes ces tables partagent la colonne id_device et sont fréquemment jointes pour obtenir l'état ou l'inventaire d'un appareil.
-- Le cluster permet de stocker ensemble les lignes qui partagent le même id_device, améliorant la performance des jointures.
CREATE CLUSTER cluster_device (id_device NUMBER)
SIZE 1024
TABLESPACE Device_network;

CREATE INDEX idx_cluster_device ON CLUSTER cluster_device;

CREATE TABLE DEVICE (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    type VARCHAR2(50),
    price NUMBER,
    ip_address VARCHAR2(50),
    buying_date DATE,
    guaranty_expiration_date DATE,
    id_network NUMBER
) CLUSTER cluster_device (id);

CREATE TABLE PERIPHERAL (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    type VARCHAR2(50),
    price NUMBER,
    buying_date DATE,
    id_device NUMBER
) CLUSTER cluster_device (id_device);

CREATE TABLE VM (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    id_device NUMBER NOT NULL
) CLUSTER cluster_device (id_device);

CREATE TABLE LICENCE_DEVICE (
    id NUMBER PRIMARY KEY,
    price NUMBER,
    expiration_date DATE,
    buying_date DATE,
    id_device NUMBER
) CLUSTER cluster_device (id_device);

-- Cluster 2 : GLPI_USER et TICKET
-- parce que les tickets sont fréquemment reliés à un utilisateur via une clé étrangère (id_created_by).
-- Le cluster permet de stocker ensemble les tickets et leurs auteurs, améliorant l'efficacité des recherches utilisateur/ticket.
CREATE CLUSTER cluster_user_ticket (id NUMBER)
SIZE 1024
TABLESPACE User_group;

CREATE INDEX idx_cluster_user_ticket ON CLUSTER cluster_user_ticket;

CREATE TABLE GLPI_USER (
    id NUMBER PRIMARY KEY,
    last_name VARCHAR2(100),
    first_name VARCHAR2(100)
) CLUSTER cluster_user_ticket (id);

CREATE TABLE TICKET (
    id NUMBER PRIMARY KEY,
    subject VARCHAR2(255),
    description VARCHAR2(255),
    statut VARCHAR2(50) DEFAULT 'OPEN',
    ticket_creation_date DATE DEFAULT SYSDATE,
    id_created_by NUMBER,
    id_project NUMBER
) CLUSTER cluster_user_ticket (id_created_by);

-- Cluster 3 : INTERVENTION et AFFECTATION
-- parce que les affectations d'utilisateurs à des interventions sont fréquentes.
-- Le cluster améliore les performances de requêtes comme "quelles affectations sont liées à une intervention donnée ?"
CREATE CLUSTER cluster_intervention (id_intervention NUMBER)
SIZE 1024
TABLESPACE Project_management;

CREATE INDEX idx_cluster_intervention ON CLUSTER cluster_intervention;

CREATE TABLE INTERVENTION (
    id NUMBER PRIMARY KEY,
    inter_date DATE,
    price NUMBER,
    description VARCHAR2(255),
    type VARCHAR2(50),
    id_device NUMBER NOT NULL
) CLUSTER cluster_intervention (id);

CREATE TABLE AFFECTATION (
    id NUMBER PRIMARY KEY,
    date_affectation DATE,
    id_user NUMBER NOT NULL,
    id_intervention NUMBER NOT NULL,
    id_ticket NUMBER NOT NULL
) CLUSTER cluster_intervention (id_intervention);
