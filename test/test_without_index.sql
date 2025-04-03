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

SELECT * FROM TABLE(DBMS_XPLAN.sDISPLAY);

EXPLAIN PLAN FOR
SELECT * FROM TICKET WHERE statut = 'OPEN';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);