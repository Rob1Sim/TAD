alter session set "_ORACLE_SCRIPT"=true;

-- Tablespace
CREATE TABLESPACE User_group 
DATAFILE 'user_group.dbf' 
SIZE 50M 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

CREATE TABLESPACE Device_network
DATAFILE 'device_network.dbf' 
SIZE 50M 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

CREATE TABLESPACE Project_management 
DATAFILE 'project_management.dbf' 
SIZE 50M 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

DROP TABLE USER_GROUP_PERMISSIONS;
DROP TABLE USER_GROUP;
DROP TABLE PERMISSIONS;
DROP TABLE GROUPS;
DROP TABLE AFFECTATION;
DROP TABLE INTERVENTION;
DROP TABLE TICKET;
DROP TABLE PROJECT;
DROP TABLE GLPI_USER;
DROP TABLE LICENCE_DEVICE;
DROP TABLE VM;
DROP TABLE PERIPHERAL;
DROP TABLE DEVICE;
DROP TABLE NETWORK;



-- Création des TABLES
CREATE TABLE PERIPHERAL (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    type VARCHAR2(50),
    price NUMBER,
    buying_date DATE,
    id_device NUMBER
) TABLESPACE Device_network;

CREATE TABLE VM (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    id_device NUMBER NOT NULL
) TABLESPACE Device_network;

CREATE TABLE DEVICE (
    id NUMBER PRIMARY KEY,
    description VARCHAR2(255),
    type VARCHAR2(50),
    price NUMBER,
    ip_address VARCHAR2(50),
    buying_date DATE,
    guaranty_expiration_date DATE,
    id_network NUMBER
) TABLESPACE Device_network;

CREATE TABLE NETWORK (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    alias VARCHAR2(100),
    ip_address VARCHAR2(50),
    ip_mask VARCHAR2(50)
) TABLESPACE Device_network;

CREATE TABLE LICENCE_DEVICE (
    id NUMBER PRIMARY KEY,
    price NUMBER,
    expiration_date DATE,
    buying_date DATE,
    id_device NUMBER
) TABLESPACE Device_network;

CREATE TABLE INTERVENTION (
    id NUMBER PRIMARY KEY,
    inter_date DATE,
    price NUMBER,
    description VARCHAR2(255),
    type VARCHAR2(50),
    id_device NUMBER NOT NULL
) TABLESPACE Project_management;

CREATE TABLE AFFECTATION (
    id NUMBER PRIMARY KEY,
    date_affectation DATE,
    id_user NUMBER NOT NULL,
    id_intervention NUMBER NOT NULL,
    id_ticket NUMBER NOT NULL
) TABLESPACE Project_management;

CREATE TABLE TICKET (
    id NUMBER PRIMARY KEY,
    subject VARCHAR2(255),
    description VARCHAR2(255),
    statut VARCHAR2(50) DEFAULT 'OPEN',
    ticket_creation_date DATE DEFAULT SYSDATE,
    id_created_by NUMBER,
    id_project NUMBER
) TABLESPACE Project_management;

CREATE TABLE GLPI_USER (
    id NUMBER PRIMARY KEY,
    last_name VARCHAR2(100),
    first_name VARCHAR2(100)
) TABLESPACE User_group;

CREATE TABLE PROJECT (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    description VARCHAR2(255),
    creation_date DATE DEFAULT SYSDATE
) TABLESPACE Project_management;

CREATE TABLE GROUPS (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
) TABLESPACE User_group;

CREATE TABLE PERMISSIONS (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
) TABLESPACE User_group;

-- Tables NM
CREATE TABLE USER_GROUP (
    id_user NUMBER,
    id_group NUMBER,
    PRIMARY KEY (id_user, id_group),
    FOREIGN KEY (id_user) REFERENCES GLPI_USER(id),
    FOREIGN KEY (id_group) REFERENCES GROUPS(id)
) TABLESPACE User_group;


CREATE TABLE USER_GROUP_PERMISSIONS (
    id NUMBER PRIMARY KEY,
    id_user NUMBER NULL,
    id_permission NUMBER,
    id_group NUMBER NULL,
    CONSTRAINT UQ_UGP UNIQUE (id_permission, id_group,id_user),
    FOREIGN KEY (id_user) REFERENCES GLPI_USER(id),
    FOREIGN KEY (id_permission) REFERENCES PERMISSIONS(id),
    FOREIGN KEY (id_group) REFERENCES GROUPS(id),
    CONSTRAINT CHK_UGP_AT_LEAST_ONE_NOT_NULL CHECK (
        id_user IS NOT NULL OR id_group IS NOT NULL
    )
) TABLESPACE User_group;


-- Ajout des contraintes
-- Peripheral
ALTER TABLE PERIPHERAL
ADD CONSTRAINT FK_PERIPHERAL_DEVICE FOREIGN KEY (id_device)
REFERENCES DEVICE(id);

-- Device
ALTER TABLE DEVICE
ADD CONSTRAINT FK_DEVICE_LICENCE FOREIGN KEY (id_licence_device)
REFERENCES LICENCE_DEVICE(id);

ALTER TABLE DEVICE
ADD CONSTRAINT FK_DEVICE_NETWORK FOREIGN KEY (id_network)
REFERENCES NETWORK(id);

-- Intervention
ALTER TABLE INTERVENTION
ADD CONSTRAINT FK_INTERVENTION_DEVICE FOREIGN KEY (id_device)
REFERENCES DEVICE(id);

-- Affectation
ALTER TABLE AFFECTATION
ADD CONSTRAINT FK_AFFECTATION_USER FOREIGN KEY (id_user)
REFERENCES GLPI_USER(id);

ALTER TABLE AFFECTATION
ADD CONSTRAINT FK_AFFECTATION_INTERVENTION FOREIGN KEY (id_intervention)
REFERENCES INTERVENTION(id);

ALTER TABLE AFFECTATION
ADD CONSTRAINT FK_AFFECTATION_TICKET FOREIGN KEY (id_ticket)
REFERENCES TICKET(id);

-- Ticket
ALTER TABLE TICKET
ADD CONSTRAINT FK_TICKET_USER FOREIGN KEY (id_created_by)
REFERENCES GLPI_USER(id);

ALTER TABLE TICKET
ADD CONSTRAINT FK_TICKET_PROJECT FOREIGN KEY (id_project)
REFERENCES PROJECT(id);

