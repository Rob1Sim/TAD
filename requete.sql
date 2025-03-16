SELECT * FROM INTERVENTION
WHERE id_device = 1;

--Lister les interventions sur un appareil spécifique
--Sélectionner la listes de tickets en cours avec les utilisateur affecté
--Calculer les dépenses entre deux dates

SELECT 
    t.id AS ticket_id, 
    t.subject, 
    t.description, 
    t.ticket_creation_date, 
    u.id AS user_id, 
    u.first_name, 
    u.last_name
FROM TICKET t
JOIN AFFECTATION a ON t.id = a.id_ticket
JOIN GLPI_USER u ON a.id_user = u.id
WHERE t.statut = 'OPEN';

CREATE OR REPLACE FUNCTION total_depenses_func (
    start_date IN DATE,
    end_date IN DATE
) RETURN NUMBER
IS
    total NUMBER := 0;
BEGIN
    SELECT COALESCE(SUM(price), 0) INTO total
    FROM INTERVENTION
    WHERE date BETWEEN start_date AND end_date;
    FOR rec IN (SELECT id FROM DEVICE WHERE buying_date BETWEEN start_date AND end_date) LOOP
        total := total + setup_price(rec.id);
    END LOOP;
    RETURN total;
END;
/

