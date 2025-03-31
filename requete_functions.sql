-- Sélectionner toutes interventions d’un ticket
CREATE OR REPLACE PROCEDURE ticket_intervention(p_id_ticket NUMBER)
IS
    CURSOR intervention_cursor IS
        SELECT i.* FROM INTERVENTION i 
        JOIN AFFECTATION a ON  i.id = a.id_intervention
        WHERE a.id_ticket = p_id_ticket;
    
    v_intervention intervention%ROWTYPE;
BEGIN
    OPEN intervention_cursor;
    LOOP
        FETCH intervention_cursor INTO v_intervention;
        EXIT WHEN intervention_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_intervention.id ||
                     ', Date: ' || TO_CHAR(v_intervention.inter_date, 'YYYY-MM-DD') ||
                     ', Price: ' || TO_CHAR(v_intervention.price, '9999.99') ||
                     ', Description: ' || v_intervention.description ||
                     ', Type: ' || v_intervention.type);

    END LOOP;
    CLOSE intervention_cursor;
END;
/


--Sélectionner un ticket existant en fonction d’un user

CREATE OR REPLACE PROCEDURE user_ticket(p_id_user NUMBER)
IS
    CURSOR ticket_cursor IS
        SELECT i.* FROM ticket i
        JOIN AFFECTATION a ON  i.id = a.id_ticket
        WHERE a.id_user = p_id_user;
    
    v_ticket ticket%ROWTYPE;
BEGIN
    OPEN ticket_cursor;
    LOOP
        FETCH ticket_cursor INTO v_ticket;
        EXIT WHEN ticket_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_ticket.id ||
                     ', Subject: ' || v_ticket.subject ||
                     ', Description: ' || v_ticket.description ||
                     ', Statut: ' || v_ticket.statut ||
                     ', Ticket Creation Date: ' || TO_CHAR(v_ticket.ticket_creation_date, 'YYYY-MM-DD') ||
                     ', Created By: ' || v_ticket.id_created_by ||
                     ', Project ID: ' || v_ticket.id_project);

    END LOOP;
    CLOSE ticket_cursor;
END;
/

CREATE OR REPLACE PROCEDURE Device_ticket(p_id_device NUMBER)
IS
    CURSOR ticket_cursor IS
        SELECT t.*
        FROM ticket t
        JOIN AFFECTATION a ON t.id = a.id_ticket
        JOIN INTERVENTION i ON i.id = a.id_intervention
        WHERE i.id_device = p_id_device;
    
    v_ticket ticket%ROWTYPE;
BEGIN
    OPEN ticket_cursor;
    LOOP
        FETCH ticket_cursor INTO v_ticket;
        EXIT WHEN ticket_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_ticket.id ||
                     ', Subject: ' || v_ticket.subject ||
                     ', Description: ' || v_ticket.description ||
                     ', Statut: ' || v_ticket.statut ||
                     ', Ticket Creation Date: ' || TO_CHAR(v_ticket.ticket_creation_date, 'YYYY-MM-DD') ||
                     ', Created By: ' || v_ticket.id_created_by ||
                     ', Project ID: ' || v_ticket.id_project);

    END LOOP;
    CLOSE ticket_cursor;
END;
/


--Suppression d’un ticket
CREATE OR REPLACE TRIGGER TRG_DELETE_TICKET
BEFORE DELETE ON TICKET
FOR EACH ROW
BEGIN
    
    -- Supprimer les interventions associées au ticket
    DELETE FROM INTERVENTION 
    WHERE id IN (SELECT id_intervention FROM AFFECTATION WHERE id_ticket = :OLD.id);

    -- Supprimer les affectations associées au ticket
    DELETE FROM AFFECTATION WHERE id_ticket = :OLD.id;
    COMMIT;
END;
/
--Update d’un ticket
CREATE OR REPLACE PROCEDURE make_opened_ticket(p_id_ticket NUMBER)
IS
BEGIN 
    UPDATE TICKET SET statut = 'opened' WHERE id = p_id_ticket;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE make_close_ticket(p_id_ticket NUMBER)
IS
BEGIN 
    UPDATE TICKET SET statut = 'closed' WHERE id = p_id_ticket;
    COMMIT;
END;
/



-- Sélectionner tous les tickets ouverts (en cours) à une date précise.
CREATE OR REPLACE PROCEDURE Date_ticket(p_date DATE)
IS
    CURSOR ticket_cursor IS
        SELECT t.* FROM ticket t WHERE t.ticket_creation_date = p_date;
    
    v_ticket ticket%ROWTYPE;
BEGIN
    OPEN ticket_cursor;
    LOOP
        FETCH ticket_cursor INTO v_ticket;
        EXIT WHEN ticket_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_ticket.id ||
                     ', Subject: ' || v_ticket.subject ||
                     ', Description: ' || v_ticket.description ||
                     ', Statut: ' || v_ticket.statut ||
                     ', Ticket Creation Date: ' || TO_CHAR(v_ticket.ticket_creation_date, 'YYYY-MM-DD') ||
                     ', Created By: ' || v_ticket.id_created_by ||
                     ', Project ID: ' || v_ticket.id_project);
    END LOOP;
    CLOSE ticket_cursor;
END;
/

-- Fonction: Calculer le prix d’un ticket/projet
CREATE OR REPLACE FUNCTION ticket_price(p_id_ticket NUMBER)
RETURN NUMBER
IS
    ticket_total_price NUMBER := 0;
BEGIN
    SELECT COALESCE(SUM(i.price), 0) --remplace NULL par 0
    INTO ticket_total_price
    FROM INTERVENTION i
    JOIN AFFECTATION a ON i.id = a.id_intervention
    WHERE a.id_ticket = p_id_ticket;

    RETURN ticket_total_price;
END;
/

CREATE OR REPLACE FUNCTION project_price(p_id_project NUMBER)
RETURN NUMBER
IS
    total_project_price NUMBER := 0;
    temp_ticket_price NUMBER;
BEGIN
    FOR rec IN (SELECT t.id FROM TICKET t WHERE t.id_project = p_id_project) 
    LOOP
        temp_ticket_price := ticket_price(rec.id);
        total_project_price := total_project_price + temp_ticket_price;
    END LOOP;

    RETURN total_project_price;
END;
/

CREATE OR REPLACE FUNCTION total_depenses_func (
    start_date IN DATE,
    end_date IN DATE
) RETURN NUMBER
IS
    total NUMBER := 0;
BEGIN
    -- Calcul des dépenses des interventions
    SELECT COALESCE(SUM(price), 0) INTO total
    FROM INTERVENTION
    WHERE inter_date  BETWEEN start_date AND end_date;

    -- Ajout du coût d'installation des appareils achetés
    FOR rec IN (SELECT id FROM DEVICE WHERE buying_date BETWEEN start_date AND end_date) LOOP
        total := total + NVL(setup_price(rec.id), 0); --  Évite les erreurs si setup_price retourne NULL
    END LOOP;

    RETURN total;
END;
/
