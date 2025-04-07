-- Analysons ce ticket
SELECT * FROM Ticket
WHERE id = 1;
 
-- 2. Affecter le ticket
SELECT * FROM AFFECTATION
WHERE id_ticket = 1;

--Trouver une intervention
SELECT * FROM INTERVENTION
WHERE id = 1;
 
-- 3. Afficher les infos de la machine
exec get_all_info_device(1);
SELECT SETUP_PRICE(1) FROM DUAL;


-- 5. Toute les interventions sont terminées
UPDATE INTERVENTION i
SET type = 'CLÔTURÉE'
WHERE i.id IN (
    SELECT a.id_intervention
    FROM AFFECTATION a
    WHERE a.id_ticket = 1
);


