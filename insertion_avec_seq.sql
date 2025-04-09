CREATE OR REPLACE PROCEDURE generate_data (
    nb_users           IN NUMBER,
    nb_groups          IN NUMBER,
    nb_permissions     IN NUMBER,
    nb_projects        IN NUMBER,
    nb_networks        IN NUMBER,
    nb_licences        IN NUMBER,
    nb_devices         IN NUMBER,
    nb_peripherals     IN NUMBER
) IS
BEGIN
    -- Utilisateurs
    FOR i IN 1..nb_users LOOP
        INSERT INTO GLPI_USER (id, last_name, first_name)
        VALUES (
            seq_glpi_user_id.NEXTVAL,
            'Nom_' || i,
            'Prenom_' || i
        );
    END LOOP;

    -- Groupes
    FOR i IN 1..nb_groups LOOP
        INSERT INTO GROUPS (id, name)
        VALUES (
            seq_groups_id.NEXTVAL,
            'Groupe_' || i
        );
    END LOOP;

    -- Permissions
    FOR i IN 1..nb_permissions LOOP
        INSERT INTO PERMISSIONS (id, name)
        VALUES (
            seq_permissions_id.NEXTVAL,
            'Permission_' || i
        );
    END LOOP;

    -- Projets
    FOR i IN 1..nb_projects LOOP
        INSERT INTO PROJECT (id, name, description)
        VALUES (
            seq_project_id.NEXTVAL,
            'Projet_' || i,
            'Description du projet ' || i
        );
    END LOOP;

    -- Réseaux
    FOR i IN 1..nb_networks LOOP
        INSERT INTO NETWORK (id, name, alias, ip_address, ip_mask)
        VALUES (
            seq_network_id.NEXTVAL,
            'Réseau_' || i,
            'Alias_' || i,
            '192.168.' || i || '.0',
            '255.255.255.0'
        );
    END LOOP;

    -- Licences
    FOR i IN 1..nb_licences LOOP
        INSERT INTO LICENCE_DEVICE (id, price, expiration_date, buying_date, id_device)
        VALUES (
            seq_licence_device_id.NEXTVAL,
            ROUND(DBMS_RANDOM.VALUE(100, 500), 2),
            SYSDATE + DBMS_RANDOM.VALUE(100, 1000),
            SYSDATE - DBMS_RANDOM.VALUE(100, 1000),
            NULL
        );
        
    END LOOP;

    -- Devices
    FOR i IN 1..nb_devices LOOP
        INSERT INTO DEVICE (
            id, description, type, price, ip_address,
            buying_date, guaranty_expiration_date, id_network
        )
        VALUES (
            seq_device_id.NEXTVAL,
            'Device_' || i,
            CASE MOD(i, 3) WHEN 0 THEN 'Laptop' WHEN 1 THEN 'Desktop' ELSE 'Server' END,
            ROUND(DBMS_RANDOM.VALUE(300, 1500), 2),
            '10.0.0.' || i,
            SYSDATE - DBMS_RANDOM.VALUE(1, 365),
            SYSDATE + DBMS_RANDOM.VALUE(365, 1000),
            MOD(i, GREATEST(nb_networks,1)) + 1
        );
    END LOOP;

    -- Périphériques
    FOR i IN 1..nb_peripherals LOOP
        INSERT INTO PERIPHERAL (
            id, description, type, price, buying_date, id_device
        )
        VALUES (
            seq_peripheral_id.NEXTVAL,
            'Périphérique_' || i,
            CASE MOD(i, 2) WHEN 0 THEN 'Clavier' ELSE 'Souris' END,
            ROUND(DBMS_RANDOM.VALUE(20, 100), 2),
            SYSDATE - DBMS_RANDOM.VALUE(1, 300),
            MOD(i, GREATEST(nb_devices,1)) + 1
        );
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Données générées avec succès.');
END;
/

BEGIN
    generate_data(
        nb_users => 1000,

        nb_groups => 5000,
        nb_permissions => 5000,
        nb_projects => 5000,
        nb_networks => 3000,
        nb_licences => 5000,
        nb_devices => 1000,
        nb_peripherals => 8000
    );
END;
/

SELECT * FROM GLPI_USER ;
SELECT * FROM PERIPHERAL;
SELECT * FROM DEVICE ;
SELECT * FROM LICENCE_DEVICE ;
