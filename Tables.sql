-- CREATE DATABASE Gestion_Informatique;
-- USE Gestion_Informatique;

-- ======================
-- Table Matériel
-- ======================

CREATE TABLE Device (
    id INT PRIMARY KEY,
    object_description CLOB,
    type VARCHAR(50),
    price NUMBER(10,2),
    date_achat DATE,
    id_network INT, -- Clé étrangère vers Network
    ip_address VARCHAR(16), 
    FOREIGN KEY (id_network) REFERENCES Network(id) ON DELETE SET NULL
);

CREATE TABLE Peripheral (
    id INT PRIMARY KEY,
    id_device INT, -- Clé étrangère vers Device
    object_description CLOB,
    type VARCHAR(50),
    price NUMBER(10,2),
    date_achat DATE,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE VM (
    id INT PRIMARY KEY,
    id_device INT, -- Clé étrangère vers Device
    object_description CLOB,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE License_Device (
    id INT PRIMARY KEY,
    id_device INT, -- Clé étrangère vers Device
    price NUMBER(10,2),
    expiration_date DATE,
    date_achat DATE,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE Network (
    id INT PRIMARY KEY,
    net_alias VARCHAR(20),
    ip_address VARCHAR(16),
    ip_mask VARCHAR(16)
);


-- ======================
-- Table Utilisateur
-- ======================

CREATE TABLE User (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    first_name VARCHAR(50)
);
CREATE TABLE Glpi_group (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE Permission (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Group_user (
    -- Couple de clés primaires
    id_user INT, -- Clé étrangère vers User
    id_permission INT, -- Clé étrangère vers Permission
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
);

CREATE TABLE Group_permission (
    -- Couple de clés primaires
    id_group INT, -- Clé étrangère vers Group
    id_permission INT, -- Clé étrangère vers Permission
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES Glpi_group(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
);

-- ======================
-- Table Gestion
-- ======================

CREATE TABLE Ticket (
    id INT PRIMARY KEY,
    subject VARCHAR(255),
    object_description CLOB,
    id_user_client INT, -- Clé étrangère vers User 
    id_intervention INT, -- Clé étrangère vers Intervention
    id_projet INT, -- Clé étrangère vers Projet
    Ticket_Status VARCHAR(20),
    FOREIGN KEY (id_user_client) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_intervention) REFERENCES Intervention(id) ON DELETE SET NULL,
    FOREIGN KEY (id_projet) REFERENCES Project(id) ON DELETE SET NULL
);

CREATE TABLE Intervention (
    id INT PRIMARY KEY,
    date_intervention DATE,
    id_intervenor INT, -- Clé étrangère vers User
    id_device INT, -- Clé étrangère vers Device
    id_ticket INT, -- Clé étrangère vers Ticket
    price NUMBER(10,2),
    object_description CLOB,
    FOREIGN KEY (id_intervenor) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE SET NULL,
    FOREIGN KEY (id_ticke) REFERENCES Ticket(id) ON DELETE SET NULL
);

CREATE TABLE Project (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    object_description CLOB
);