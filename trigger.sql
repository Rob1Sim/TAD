-- TODO: a voir si on garde sachant qu'on peut faire un on delete cascade et que ça marche mieux
CREATE OR REPLACE TRIGGER TRG_delete_device
BEFORE DELETE ON DEVICE
FOR EACH ROW
BEGIN
    DELETE FROM LICENCE_DEVICE WHERE id_device = :OLD.id;
    DELETE FROM VM WHERE id = :OLD.id;
END;
/
-- TODO:same qu'au dessus
CREATE OR REPLACE TRIGGER TRG_delete_project
BEFORE DELETE ON PROJECT
FOR EACH ROW
BEGIN
    DELETE FROM TICKET WHERE id_project = :OLD.id;
END;
/
-- TODO:Pour la 3e revoir parce que ça n'a pas de sens

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
FOR EACH ROW
DECLARE
    v_count_open NUMBER;
BEGIN
    -- Vérifie s'il reste des tickets ouverts pour ce projet
    SELECT COUNT(*)
    INTO v_count_open
    FROM TICKET
    WHERE id_project = :NEW.id_project
      AND statut != 'CLOSE';

    -- Si aucun ticket ouvert et que projet existe, on modifie sa description
    IF v_count_open = 0 AND :NEW.id_project IS NOT NULL THEN
        UPDATE PROJECT
        SET description = description || ' PROJET TERMINÉ'
        WHERE id = :NEW.id_project
          AND description NOT LIKE '%PROJET TERMINÉ';
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_close_ticket_when_all_interventions_done
AFTER UPDATE OF type ON INTERVENTION
FOR EACH ROW
DECLARE
    v_ticket_id TICKET.id%TYPE;
    v_count_open NUMBER;
BEGIN
    -- Récupérer le ticket lié à cette intervention (s'il y en a un)
    SELECT id_ticket
    INTO v_ticket_id
    FROM AFFECTATION
    WHERE id_intervention = :NEW.id
    FETCH FIRST 1 ROWS ONLY;

    -- Vérifier s'il reste des interventions NON clôturées pour ce ticket
    SELECT COUNT(*)
    INTO v_count_open
    FROM AFFECTATION a
    JOIN INTERVENTION i ON a.id_intervention = i.id
    WHERE a.id_ticket = v_ticket_id
      AND UPPER(i.type) != 'CLÔTURÉE';

    -- Si plus aucune intervention non clôturée → fermer le ticket
    IF v_count_open = 0 THEN
        UPDATE TICKET
        SET statut = 'CLOSED'
        WHERE id = v_ticket_id;
    END IF;
END;
/