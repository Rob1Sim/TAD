
CREATE OR REPLACE TRIGGER TRG_before_insert_licence
BEFORE INSERT ON LICENCE_DEVICE
FOR EACH ROW
BEGIN
    IF :NEW.expiration_date < :NEW.buying_date THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date d''expiration doit être supérieure à la date d''achat');
    END IF;
    
    --IF :NEW.expiration_date < SYSDATE THEN
      --  RAISE_APPLICATION_ERROR(-20002, 'La date d''expiration doit être supérieure à la date actuelle');
    --END IF;
    IS_DATE_VALID(:NEW.expiration_date);
END;
/
CREATE OR REPLACE TRIGGER TRG_before_insert_affecation
BEFORE INSERT ON AFFECTATION
FOR EACH ROW
BEGIN
    :NEW.date_affectation := SYSDATE;   
END;
/
CREATE OR REPLACE TRIGGER TRG_before_insert_project
BEFORE INSERT ON PROJECT
FOR EACH ROW
BEGIN
    :NEW.creation_date := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_close_project_when_tickets_closed
AFTER UPDATE OF statut ON TICKET
DECLARE
    CURSOR c_projects IS
        SELECT DISTINCT id_project
        FROM TICKET
        WHERE statut = 'CLOSE'
          AND id_project IS NOT NULL;
    v_count_open NUMBER;
BEGIN
    FOR rec IN c_projects LOOP
        SELECT COUNT(*) INTO v_count_open
        FROM TICKET
        WHERE id_project = rec.id_project
          AND statut != 'CLOSE';

        IF v_count_open = 0 THEN
            UPDATE PROJECT
            SET description = description || ' PROJET TERMINÉ'
            WHERE id = rec.id_project
              AND description NOT LIKE '%PROJET TERMINÉ';
        END IF;
    END LOOP;
END;
/

CREATE OR REPLACE TRIGGER trg_close_ticket_when_all_interventions_done
AFTER UPDATE OF type ON INTERVENTION
DECLARE
    CURSOR c_tickets IS
        SELECT DISTINCT a.id_ticket
        FROM AFFECTATION a
        JOIN INTERVENTION i ON a.id_intervention = i.id
        WHERE i.type = 'CLOTUREE'
          AND i.id IN (
              SELECT id
              FROM INTERVENTION
              WHERE type = 'CLOTUREE'
                AND id IN (SELECT id FROM INTERVENTION MINUS SELECT id FROM INTERVENTION WHERE type != 'CLOTUREE')
          );

    v_count_open NUMBER;
BEGIN
    FOR rec IN c_tickets LOOP
        -- Vérifier s'il reste des interventions NON clôturées pour ce ticket
        SELECT COUNT(*)
        INTO v_count_open
        FROM AFFECTATION a
        JOIN INTERVENTION i ON a.id_intervention = i.id
        WHERE a.id_ticket = rec.id_ticket
          AND UPPER(TRIM(i.type)) != 'CLOTUREE';

        IF v_count_open = 0 THEN
            UPDATE TICKET
            SET statut = 'CLOSE'
            WHERE id = rec.id_ticket;
        END IF;
    END LOOP;
END;
/


CREATE OR REPLACE TRIGGER trg_close_ticket_when_all_interventions_done
AFTER UPDATE OF type ON INTERVENTION
DECLARE
    CURSOR c_interventions IS
        SELECT DISTINCT a.id_ticket
        FROM AFFECTATION a
        JOIN INTERVENTION i ON a.id_intervention = i.id
        WHERE i.type = 'CLOTUREE'
          AND i.id IN (
              SELECT id
              FROM INTERVENTION
              MINUS
              SELECT id
              FROM INTERVENTION
              WHERE type != 'CLOTUREE'
          );
    v_count_open NUMBER;
BEGIN
    FOR rec IN c_interventions LOOP
        -- Vérifie s'il reste des interventions non clôturées pour ce ticket
        SELECT COUNT(*)
        INTO v_count_open
        FROM AFFECTATION a
        JOIN INTERVENTION i ON a.id_intervention = i.id
        WHERE a.id_ticket = rec.id_ticket
          AND UPPER(TRIM(i.type)) != 'CLOTUREE';

        IF v_count_open = 0 THEN
            UPDATE TICKET
            SET statut = 'CLOSE'
            WHERE id = rec.id_ticket;
        END IF;
    END LOOP;
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


CREATE OR REPLACE TRIGGER trg_update_ticket_status_on_affectation
AFTER INSERT ON AFFECTATION
FOR EACH ROW
DECLARE
    v_intervention_type INTERVENTION.type%TYPE;
BEGIN
    -- Récupérer le type de l'intervention associée
    SELECT type INTO v_intervention_type
    FROM INTERVENTION
    WHERE id = :NEW.id_intervention;

    -- Vérifier si le type d'intervention est 'Maintenance' ou 'OPEN'
    IF v_intervention_type IN ('Maintenance', 'OPEN') THEN
        -- Mettre à jour le statut du ticket en 'OPEN'
        UPDATE TICKET
        SET statut = 'OPEN'
        WHERE id = :NEW.id_ticket;
    END IF;
END;
/



