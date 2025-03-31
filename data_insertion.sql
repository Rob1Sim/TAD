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

    -- Insertion de groupes
    FOR i IN 1..5 LOOP
        INSERT INTO GROUPS (id, name)
        VALUES (
            i,
            'Groupe_' || i
        );
    END LOOP;

    -- Insertion de permissions
    FOR i IN 1..5 LOOP
        INSERT INTO PERMISSIONS (id, name)
        VALUES (
            i,
            'Permission_' || i
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
    DBMS_OUTPUT.PUT_LINE('✅ Jeu de données généré avec succès.');
END;
/


-- les triggers 

CREATE OR REPLACE TRIGGER trg_check_ip_format_device
BEFORE INSERT OR UPDATE ON DEVICE
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(:NEW.ip_address, '^\d{1,3}(\.\d{1,3}){3}$') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Format IP invalide pour DEVICE');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_ip_format_network
BEFORE INSERT OR UPDATE ON NETWORK
FOR EACH ROW
BEGIN
    IF NOT REGEXP_LIKE(:NEW.ip_address, '^\d{1,3}(\.\d{1,3}){3}$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Format IP invalide pour NETWORK');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_intervention_guarantee
BEFORE INSERT OR UPDATE ON INTERVENTION
FOR EACH ROW
DECLARE
    v_guaranty DATE;
BEGIN
    SELECT guaranty_expiration_date
    INTO v_guaranty
    FROM DEVICE
    WHERE id = :NEW.id_device;

    IF :NEW.inter_date <= v_guaranty THEN
        :NEW.price := 0;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_project_closed
AFTER UPDATE OF statut ON TICKET
FOR EACH ROW
DECLARE
    v_open_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_open_count
    FROM TICKET
    WHERE id_project = :OLD.id_project AND statut != 'CLOSED';

    IF v_open_count = 0 THEN
        UPDATE PROJECT
        SET description = description || ' (Projet clos)'
        WHERE id = :OLD.id_project;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_project_closed
AFTER UPDATE OF statut ON TICKET
FOR EACH ROW
DECLARE
    v_open_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_open_count
    FROM TICKET
    WHERE id_project = :OLD.id_project AND statut != 'CLOSED';

    IF v_open_count = 0 THEN
        UPDATE PROJECT
        SET description = description || ' (Projet clos)'
        WHERE id = :OLD.id_project;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_project_open
AFTER INSERT OR UPDATE OF statut ON TICKET
FOR EACH ROW
DECLARE
    v_proj_desc PROJECT.description%TYPE;
BEGIN
    IF :NEW.statut = 'OPEN' THEN
        SELECT description INTO v_proj_desc
        FROM PROJECT
        WHERE id = :NEW.id_project;

        IF INSTR(v_proj_desc, ' (Projet clos)') > 0 THEN
            UPDATE PROJECT
            SET description = REPLACE(description, ' (Projet clos)', '')
            WHERE id = :NEW.id_project;
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_open_ticket_on_null_intervention_date
AFTER INSERT ON INTERVENTION
FOR EACH ROW
DECLARE
    v_ticket_id NUMBER;
BEGIN
    IF :NEW.inter_date IS NULL THEN
        SELECT a.id_ticket INTO v_ticket_id
        FROM AFFECTATION a
        WHERE a.id_intervention = :NEW.id;

        UPDATE TICKET
        SET statut = 'OPEN'
        WHERE id = v_ticket_id;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; -- Pas d'affectation encore liée, on ignore.
END;
/



--test sans index
DROP INDEX idx_bill_date;
DROP INDEX idx_device_type_bitmap;
DROP INDEX idx_ticket_statut;

DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM BILL
        WHERE date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD')
                      AND TO_DATE('2023-12-31', 'YYYY-MM-DD')
    )
    LOOP
        NULL; -- on itère sans afficher pour simuler
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('⏱ Temps BILL.date (sans index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/

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

    DBMS_OUTPUT.PUT_LINE('⏱ Temps DEVICE.type (sans index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
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

    DBMS_OUTPUT.PUT_LINE('⏱ Temps TICKET.statut (sans index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/

--index

CREATE INDEX idx_bill_date
ON BILL(date);

CREATE BITMAP INDEX idx_device_type_bitmap
ON DEVICE(type);


CREATE INDEX idx_ticket_statut
ON TICKET(statut);


DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;

    FOR r IN (
        SELECT * FROM BILL
        WHERE date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD')
                      AND TO_DATE('2023-12-31', 'YYYY-MM-DD')
    )
    LOOP
        NULL;
    END LOOP;

    end_time := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('✅ Temps BILL.date (avec index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/



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

    DBMS_OUTPUT.PUT_LINE('✅ Temps DEVICE.type (avec index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
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

    DBMS_OUTPUT.PUT_LINE('✅ Temps TICKET.statut (avec index) : ' || TO_CHAR((end_time - start_time)/100) || ' secondes');
END;
/



-- proposition chatgpt

SET AUTOTRACE ON;


EXPLAIN PLAN FOR
SELECT * FROM BILL WHERE date BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-12-31', 'YYYY-MM-DD');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR
SELECT * FROM DEVICE WHERE type = 'Laptop';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT * FROM TICKET WHERE statut = 'OPEN';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

