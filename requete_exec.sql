
-- toute les interventions sur un device
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



--TEST
--Tout les ticket d'un users
EXEC user_ticket(1);
--Tout les ticket d'une intervention
EXEC ticket_intervention(1);
--Tout les ticket d'un device
EXEC Device_ticket(1);
--ouvrir ou fermer des tickets
EXEC make_opened_ticket(2);
EXEC make_close_ticket(3);
--Sélectionner tous les tickets avec un statut précis.
SELECT * FROM TICKET WHERE statut = 'opened';
SELECT * FROM TICKET WHERE statut = 'closed';
EXEC Date_ticket(TO_DATE('2025-01-15', 'YYYY-MM-DD'));
DBMS_OUTPUT.PUT_LINE('Le prix total du projet est : ' || project_price(1));
--Sélectionner tous les tickets avec un statut précis.

SELECT * FROM TICKET WHERE statut = 'opened';
SELECT * FROM TICKET WHERE statut = 'closed';

--toute les dépenses entre deux dates
EXEC total_depenses_func(TO_DATE('2025-03-31', 'YYYY-MM-DD'), TO_DATE('2025-03-31', 'YYYY-MM-DD'))