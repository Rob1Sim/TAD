-- Affiche la liste des licences et leurs dates d'expiration
CREATE OR REPLACE PROCEDURE get_all_licences_expirations_date IS
    CURSOR c_licences IS
        SELECT * FROM LICENCE_DEVICE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Liste des licences et leurs dates d''expiration');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
    DBMS_OUTPUT.PUT_LINE('|Id licence | Date d''expiration|');
    FOR licence IN c_licences LOOP
       DBMS_OUTPUT.PUT_LINE('|     '|| licence.id || '      |     ' || licence.expiration_date|| '   |');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
END;

-- Vérifie si une date est valide
CREATE OR REPLACE PROCEDURE is_date_valid(p_date DATE) IS
BEGIN
    IF p_date < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date doit être supérieure à la date actuelle');
    END IF;
END;

-- Ajoute ou modifie un user 
-- Séquence de GLPI_USER_ID
CREATE SEQUENCE GLPI_USER_ID
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE PROCEDURE add_or_update_user(
    p_id IN GLPI_USER.id%TYPE,
    p_last_name IN VARCHAR2,
    p_first_name IN VARCHAR2
) IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM GLPI_USER WHERE id = p_id;
    IF v_count = 0 THEN
        INSERT INTO GLPI_USER(id, last_name, first_name) VALUES(GLPI_USER_ID.NEXTVAL, p_last_name, p_first_name);
    ELSE
        UPDATE GLPI_USER SET last_name = p_last_name, first_name = p_first_name WHERE id = p_id;
    END IF;
END;
