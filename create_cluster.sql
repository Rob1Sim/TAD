DROP TABLE PERIPHERAL CASCADE CONSTRAINTS;
DROP TABLE VM CASCADE CONSTRAINTS;
DROP TABLE LICENCE_DEVICE CASCADE CONSTRAINTS;
DROP TABLE INTERVENTION CASCADE CONSTRAINTS;
DROP TABLE DEVICE CASCADE CONSTRAINTS;


-- Cluster 1 : DEVICE et ses dépendants (PERIPHERAL, VM, LICENCE_DEVICE, INTERVENTION)
-- parceque Toutes ces tables partagent la colonne id_device et sont fréquemment jointes pour obtenir l'état ou l'inventaire d'un appareil.
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

CREATE TABLE INTERVENTION (
    id NUMBER PRIMARY KEY,
    inter_date DATE,
    price NUMBER,
    description VARCHAR2(255),
    type VARCHAR2(50),
    id_device NUMBER NOT NULL
) CLUSTER cluster_device (id_device);

-- Cluster 2 : INTERVENTION et AFFECTATION
-- parcque Les affectations d'utilisateurs à des interventions sont fréquentes.
-- Le cluster améliore les performances de requêtes comme "quelles affectations sont liées à une intervention donnée ?"
CREATE CLUSTER cluster_intervention (id_intervention NUMBER)
SIZE 1024
TABLESPACE Project_management;

CREATE INDEX idx_cluster_intervention ON CLUSTER cluster_intervention;

CREATE TABLE AFFECTATION (
    id NUMBER PRIMARY KEY,
    date_affectation DATE,
    id_user NUMBER NOT NULL,
    id_intervention NUMBER NOT NULL,
    id_ticket NUMBER NOT NULL
) CLUSTER cluster_intervention (id_intervention);
