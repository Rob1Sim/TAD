-- génération de donnée

BEGIN
    -- Insertion d'utilisateurs
    FOR i IN 1..10 LOOP
        INSERT INTO GLPI_USER (id, last_name, first_name)
        VALUES (
            i,
            'Nom_' || i,
            'Prenom_' || i
        );
    END LOOP;

    -- Insertion de projets
    FOR i IN 1..5 LOOP
        INSERT INTO PROJECT (id, name, description)
        VALUES (
            i,
            'Projet_' || i,
            'Description du projet ' || i
        );
    END LOOP;

    -- Insertion de réseaux
    FOR i IN 1..3 LOOP
        INSERT INTO NETWORK (id, name, alias, ip_address, ip_mask)
        VALUES (
            i,
            'Réseau_' || i,
            'Alias_' || i,
            '192.168.' || i || '.0',
            '255.255.255.0'
        );
    END LOOP;

    -- Insertion de licences
    FOR i IN 1..5 LOOP
        INSERT INTO LICENCE_DEVICE (id, price, expiration_date, buying_date, id_device)
        VALUES (
            i,
            ROUND(DBMS_RANDOM.VALUE(100, 500), 2),
            SYSDATE + DBMS_RANDOM.VALUE(100, 1000),
            SYSDATE - DBMS_RANDOM.VALUE(100, 1000),
            NULL
        );
    END LOOP;

    -- Insertion de devices
    FOR i IN 1..10 LOOP
        INSERT INTO DEVICE (
            id, description, type, price, ip_address,
            buying_date, guaranty_expiration_date, id_network
        )
        VALUES (
            i,
            'Device_' || i,
            CASE MOD(i, 3) WHEN 0 THEN 'Laptop' WHEN 1 THEN 'Desktop' ELSE 'Server' END,
            ROUND(DBMS_RANDOM.VALUE(300, 1500), 2),
            '10.0.0.' || i,
            SYSDATE - DBMS_RANDOM.VALUE(1, 365),
            SYSDATE + DBMS_RANDOM.VALUE(365, 1000),
            MOD(i, 3) + 1
        );
    END LOOP;

    -- Insertion de périphériques
    FOR i IN 1..8 LOOP
        INSERT INTO PERIPHERAL (
            id, description, type, price, buying_date, id_device
        )
        VALUES (
            i,
            'Périphérique_' || i,
            CASE MOD(i, 2) WHEN 0 THEN 'Clavier' ELSE 'Souris' END,
            ROUND(DBMS_RANDOM.VALUE(20, 100), 2),
            SYSDATE - DBMS_RANDOM.VALUE(1, 300),
            MOD(i, 10) + 1
        );
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Jeu de données généré avec succès.');
END;
/

SELECT * FROM GLPI_USER;

DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM DEVICE
        WHERE type = 'Laptop'
    )
    LOOP
        NULL;
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Temps DEVICE.type (sans index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/

DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM TICKET
        WHERE statut = 'OPEN'
    )
    LOOP
        NULL;
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Temps TICKET.statut (sans index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/

--index


DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM DEVICE
        WHERE type = 'Laptop'
    )
    LOOP
        NULL;
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Temps DEVICE.type (avec index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/

DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM TICKET
        WHERE statut = 'OPEN'
    )
    LOOP
        NULL;
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Temps TICKET.statut (avec index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/


SET AUTOTRACE ON;


EXPLAIN PLAN FOR
SELECT * FROM DEVICE WHERE type = 'Laptop';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT * FROM TICKET WHERE statut = 'OPEN';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

