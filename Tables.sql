CREATE DATABASE Gestion_Informatique;
USE Gestion_Informatique;

-- ======================
-- Tablespace creation
-- ======================

-- One tablespace per table category (device and network are put together)

-- NB : size may be changed later on

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

-- ======================
-- Material Tables
-- ======================

CREATE TABLE Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    object_description CLOB,
    type VARCHAR(50),
    price DECIMAL(10,2),
    date_achat DATE,
    id_network INT, -- Foreign key towards Network
    ip_address VARCHAR(16), 
    FOREIGN KEY (id_network) REFERENCES Network(id) ON DELETE SET NULL
)TABLESPACE Device_network;

CREATE TABLE Peripheral (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT, -- Foreign key towards Device
    object_description CLOB,
    type VARCHAR(50),
    price DECIMAL(10,2),
    date_achat DATE,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
)TABLESPACE Device_network;

CREATE TABLE VM (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT, -- Foreign key towards Device
    object_description CLOB,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
)TABLESPACE Device_network;

CREATE TABLE License_Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT, -- Foreign key towards Device
    price DECIMAL(10,2),
    expiration_date DATE,
    date_achat DATE,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
)TABLESPACE Device_network;

CREATE TABLE Network (
    id INT PRIMARY KEY AUTO_INCREMENT,
    net_alias VARCHAR(20),
    ip_address VARCHAR(16),
    ip_mask VARCHAR(16)
)TABLESPACE Device_network;


-- ======================
-- User Tables
-- ======================

CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    first_name VARCHAR(50)
)TABLESPACE user_group;
CREATE TABLE Glpi_group (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);
CREATE TABLE Permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
)TABLESPACE user_group;

CREATE TABLE Group_user (
    -- Couple of primary keys
    id_user INT, -- Foreign key towards User
    id_permission INT, -- Foreign key towards Permission
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
)TABLESPACE user_group;

CREATE TABLE Group_permission (
    -- Couple of primary keys
    id_group INT, -- Foreign key towards Group
    id_permission INT, -- Foreign key towards Permission
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES Glpi_group(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
)TABLESPACE user_group;

-- ======================
-- Management Tables 
-- ======================

CREATE TABLE Ticket (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject VARCHAR(255),
    object_description CLOB,
    id_user_client INT, -- Foreign key towards User 
    id_intervention INT, -- Foreign key towards Intervention
    id_projet INT, -- Foreign key towards Projet
    Ticket_Status VARCHAR(20),
    FOREIGN KEY (id_user_client) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_intervention) REFERENCES Intervention(id) ON DELETE SET NULL,
    FOREIGN KEY (id_projet) REFERENCES Project(id) ON DELETE SET NULL
)TABLESPACE Project_management;

CREATE TABLE Intervention (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_intervention DATE,
    id_intervenor INT, -- Foreign key towards User
    id_device INT, -- Foreign key towards Device
    id_ticket INT, -- Foreign key towards Ticket
    price DECIMAL(10,2),
    object_description CLOB,
    FOREIGN KEY (id_intervenor) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE SET NULL,
    FOREIGN KEY (id_ticke) REFERENCES Ticket(id) ON DELETE SET NULL
)TABLESPACE Project_management;

CREATE TABLE Project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    object_description CLOB
)TABLESPACE Project_management;