CREATE DATABASE Gestion_Informatique;
USE Gestion_Informatique;

-- ======================
-- Table Matériel
-- ======================

CREATE TABLE Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    object_description CLOB,
    type VARCHAR(50),
    price DECIMAL(10,2),
    id_network INT, -- Clé étrangère vers Network
    ip_address VARCHAR(16),
    FOREIGN KEY (id_network) REFERENCES Network(id) ON DELETE SET NULL
);

CREATE TABLE Peripheral (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT,
    object_description CLOB,
    type VARCHAR(50),
    price DECIMAL(10,2),
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE VM (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT,
    object_description CLOB,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE License_Device (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_device INT,
    price DECIMAL(10,2),
    expiration_date DATE,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE CASCADE
);

CREATE TABLE License_User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT,
    price DECIMAL(10,2),
    expiration_date DATE,
    FOREIGN KEY (id_user) REFERENCES User(id) ON DELETE CASCADE
);

CREATE TABLE Network (
    id INT PRIMARY KEY AUTO_INCREMENT,
    net_alias VARCHAR(20),
    ip_address VARCHAR(16),
    ip_mask VARCHAR(16)
);


-- ======================
-- Table Utilisateur
-- ======================

CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    first_name VARCHAR(50)
);
CREATE TABLE Glpi_group (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);
CREATE TABLE Permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE Group_user (
    id_user INT,
    id_permission INT,
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
);

CREATE TABLE Group_permission (
    id_group INT,
    id_permission INT,
    PRIMARY KEY (id_group, id_permission),
    FOREIGN KEY (id_group) REFERENCES Glpi_group(id) ON DELETE CASCADE,
    FOREIGN KEY (id_permission) REFERENCES Permission(id) ON DELETE CASCADE
);

-- ======================
-- Table Gestion
-- ======================

CREATE TABLE Ticket (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject VARCHAR(255),
    object_description CLOB,
    id_user_client INT,
    id_intervention INT,
    id_projet INT,
    Ticket_Status VARCHAR(20),
    FOREIGN KEY (id_user_client) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_intervention) REFERENCES Intervention(id) ON DELETE SET NULL,
    FOREIGN KEY (id_projet) REFERENCES Project(id) ON DELETE SET NULL
);

CREATE TABLE Intervention (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    id_intervenor INT,
    id_device INT,
    id_ticket INT,
    price DECIMAL(10,2),
    object_description CLOB,
    FOREIGN KEY (id_intervenor) REFERENCES User(id) ON DELETE SET NULL,
    FOREIGN KEY (id_device) REFERENCES Device(id) ON DELETE SET NULL,
    FOREIGN KEY (id_ticke) REFERENCES Ticket(id) ON DELETE SET NULL
);

CREATE TABLE Bill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    total DECIMAL(10,2),
    name VARCHAR(50)
);

CREATE TABLE Project (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    object_description CLOB
);