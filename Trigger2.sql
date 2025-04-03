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
