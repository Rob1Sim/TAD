-- TODO: a voir si on garde sachant qu'on peut faire un on delete cascade et que ça marche mieux
CREATE OR REPLACE TRIGGER TRG_delete_device
BEFORE DELETE ON DEVICE
FOR EACH ROW
BEGIN
    DELETE FROM LICENCE_DEVICE WHERE device_id = :OLD.id;
    DELETE FROM VM WHERE id = :OLD.id;
END;

-- TODO:same qu'au dessus
CREATE OR REPLACE TRIGGER TRG_delete_project
BEFORE DELETE ON PROJECT
FOR EACH ROW
BEGIN
    DELETE FROM TICKET WHERE id_project = :OLD.id;
END;

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

CREATE OR REPLACE TRIGGER TRG_before_insert_affecation
BEFORE INSERT ON AFFECTATION
FOR EACH ROW
BEGIN
    :NEW.date_affectation := SYSDATE;   
END;

CREATE OR REPLACE TRIGGER TRG_before_insert_project
BEFORE INSERT ON PROJECT
FOR EACH ROW
BEGIN
    :NEW.creation_date := SYSDATE;
END;

