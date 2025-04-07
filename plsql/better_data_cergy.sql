DECLARE
    -- Variables pour contrôler le nombre de réseaux et de dispositifs
    NUMBER_OF_NETWORKS NUMBER := 2;  -- Nombre de réseaux à générer
    NUMBER_OF_DEVICES NUMBER := 10;  -- Nombre de dispositifs à générer
    NUMBER_OF_PROJECTS NUMBER := 3;  -- Nombre de projets pour répartir les tickets
    NUMBER_OF_GROUPS NUMBER := 5;  -- Nombre de groupes à créer
    NUMBER_OF_USERS NUMBER := 10;  -- Nombre d'utilisateurs à créer (au moins 5)
    NUMBER_OF_PERMISSIONS NUMBER := 8;  -- Nombre de permissions à créer
    
    -- Variables pour générer des données aléatoires
    v_device_id NUMBER;
    v_network_id NUMBER;
    v_ticket_id NUMBER;
    v_project_id NUMBER;
    v_intervention_id NUMBER;
    v_peripheral_id NUMBER;
    v_device_description VARCHAR2(255);
    v_peripheral_description VARCHAR2(255);
    v_license_price NUMBER;                
    v_license_expiration_date DATE;    
    v_license_buying_date DATE; 
    -- Listes de prénoms et de noms fictifs pour générer des noms d'utilisateurs aléatoires
    TYPE NameArray IS TABLE OF VARCHAR2(100);
    FIRST_NAMES NameArray := NameArray('John', 'Jane', 'Max', 'Maya', 'Leo', 'Lila', 'Tom', 'Ella', 'Alex', 'Lena');
    LAST_NAMES NameArray := NameArray('Smith', 'Jones', 'Taylor', 'Brown', 'Davis', 'Wilson', 'Moore', 'Clark', 'Adams', 'Scott');
    
    -- Variables pour générer des données aléatoires
    v_group_id NUMBER;
    v_user_id NUMBER;
    v_permission_id NUMBER;
    v_first_name VARCHAR2(100);
    v_last_name VARCHAR2(100);

BEGIN
        -- Créer des groupes
    FOR i IN 1..NUMBER_OF_GROUPS LOOP
        INSERT INTO GROUPS (id, name)
        VALUES (seq_groups_id.nextval, 'Group ' || i);
    END LOOP;

    -- Créer des utilisateurs avec des noms générés aléatoirement
    FOR i IN 1..NUMBER_OF_USERS LOOP
        -- Sélectionner un prénom et un nom de famille aléatoire à partir des listes
        v_first_name := FIRST_NAMES(TRUNC(DBMS_RANDOM.VALUE(1, 11)));
        v_last_name := LAST_NAMES(TRUNC(DBMS_RANDOM.VALUE(1, 11)));

        -- Créer l'utilisateur avec un nom et prénom aléatoire
        INSERT INTO GLPI_USER (id, last_name, first_name)
        VALUES (seq_glpi_user_id.NEXTVAL, v_last_name, v_first_name);
    END LOOP;

    -- Créer des permissions
    FOR i IN 1..NUMBER_OF_PERMISSIONS LOOP
        INSERT INTO PERMISSIONS (id, name)
        VALUES (seq_permissions_id.nextval, 'Permission ' || i);
    END LOOP;

    -- Associer les utilisateurs aux groupes et permissions aléatoirement
    FOR i IN 1..NUMBER_OF_USERS LOOP
        v_user_id := i;

        -- Associer chaque utilisateur à un groupe aléatoire
        v_group_id := MOD(i, NUMBER_OF_GROUPS) + 1;  -- Répartition aléatoire des groupes
        
        INSERT INTO USER_GROUP (id_user, id_group)
        VALUES (v_user_id, v_group_id);
        
        -- Associer chaque utilisateur à une permission aléatoire
        FOR j IN 1..3 LOOP  -- Chaque utilisateur obtient 3 permissions
            v_permission_id := MOD((i - 1) * 3 + j - 1, NUMBER_OF_PERMISSIONS) + 1;

            
            -- Insérer dans la table USER_GROUP_PERMISSIONS
            INSERT INTO USER_GROUP_PERMISSIONS (id, id_user, id_permission, id_group)
            VALUES (SEQ_GROUP_PERMISSIONS_ID.NEXTVAL ,v_user_id, v_permission_id, v_group_id);
        END LOOP;
    END LOOP;

    
    -- Créer des projets
    FOR i IN 1..NUMBER_OF_PROJECTS LOOP
        INSERT INTO PROJECT (id, name, description, creation_date)
        VALUES (seq_project_id.nextval, 'Project ' || i, 'Description for Project ' || i, SYSDATE);
    END LOOP;

    -- Créer des réseaux
    FOR i IN 1..NUMBER_OF_NETWORKS LOOP
        INSERT INTO NETWORK (id, name, alias, ip_address, ip_mask)
        VALUES (seq_network_id.nextval, 'Network ' || i, 'Alias ' || i, '192.168.' || i || '.1', '255.255.255.0');
    END LOOP;

    -- Créer des dispositifs et les associer à un réseau
    FOR i IN 1..NUMBER_OF_DEVICES LOOP
        v_device_description := 'Device ' || i || ' Description';
        v_network_id := MOD(i, NUMBER_OF_NETWORKS) + 1;  -- Répartition des dispositifs entre les réseaux
        v_license_price := 50 + (DBMS_RANDOM.VALUE(1, 100));  -- Prix de la licence entre 50 et 150
        v_license_expiration_date := SYSDATE + INTERVAL '1' YEAR + DBMS_RANDOM.VALUE(0, 365);  -- Date d'expiration dans 1 à 2 ans
        v_license_buying_date := SYSDATE - INTERVAL '30' DAY + DBMS_RANDOM.VALUE(0, 30);  -- Date d'achat dans les 30 derniers jours
        v_ticket_id := seq_ticket_id.nextval;
        v_project_id := MOD(i, NUMBER_OF_PROJECTS) + 1;  -- Répartition des tickets sur 3 projets
        INSERT INTO VM (id, description, id_device)
        VALUES (seq_vm_id.nextval, 'VM n°' || i, i);

        INSERT INTO LICENCE_DEVICE (id, price, expiration_date, buying_date, id_device)
        VALUES (seq_licence_device_id.nextval, v_license_price, v_license_expiration_date, v_license_buying_date, i);

        INSERT INTO DEVICE (id, description, type, price, ip_address, buying_date, guaranty_expiration_date, id_network, id_licence_device)
        VALUES (seq_device_id.nextval, v_device_description, 'Type ' || i, 100 + i, '192.168.' || v_network_id || '.' || (i + 10), SYSDATE, SYSDATE + INTERVAL '1' YEAR, v_network_id, i);
        INSERT INTO TICKET (id, subject, description, statut, ticket_creation_date, id_created_by, id_project)
        VALUES (v_ticket_id, 'Ticket ' || v_ticket_id, 'Ticket for Device ' || i, 'OPEN', SYSDATE, NULL, v_project_id);

        -- Associer 3 périphériques à chaque dispositif
        FOR j IN 1..3 LOOP
            v_peripheral_id := seq_peripheral_id.nextval;
            v_peripheral_description := 'Peripheral ' || v_peripheral_id || ' for Device ' || i;
            
            INSERT INTO PERIPHERAL (id, description, type, price, buying_date, id_device)
            VALUES (v_peripheral_id, v_peripheral_description, 'Peripheral Type', 50 + j, SYSDATE, i);
            END LOOP;

            -- Créer des interventions et les associer à des dispositifs et des tickets
            FOR j IN 1..5 LOOP
                v_intervention_id := seq_intervention_id.nextval;
                
                INSERT INTO INTERVENTION (id, inter_date, price, description, type, id_device)
                VALUES (v_intervention_id, SYSDATE + (j / 2), 150 + j, 'Intervention for Device ' || i, 'Maintenance', i);
                -- Associer une intervention à un ticket de manière aléatoire
                INSERT INTO AFFECTATION (id, date_affectation, id_user, id_intervention, id_ticket)
                VALUES (v_intervention_id, SYSDATE, j, v_intervention_id, i);
            END LOOP;
        END LOOP;



    COMMIT;
END;

