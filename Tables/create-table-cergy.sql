@create-table-all.sql

DROP TABLE USER_GROUP_PERMISSIONS;
DROP TABLE USER_GROUP;
DROP TABLE PERMISSIONS;
DROP TABLE GROUPS;


-- Pas à Pau
CREATE TABLE GROUPS (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100)
) TABLESPACE User_group;

-- Pas a Pau
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

COMMIT;