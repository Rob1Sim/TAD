

CREATE OR REPLACE FUNCTION price_ticket (id_ticket NUMBER) 
RETURN NUMBER 
IS
    res NUMBER := 0;
    CURSOR curs IS 
    SELECT price FROM Prix_Intervention
    WHERE Prix_Intervention.id = id_ticket;
    temp Prix_Intervention.PRICE%TYPE;
BEGIN
    OPEN curs;
    LOOP
        FETCH curs INTO temp;
        EXIT WHEN curs%NOTFOUND;
        res := res + temp;
    END LOOP;
    CLOSE curs;

  RETURN res;
END;
/
CREATE OR REPLACE FUNCTION price_peripheral (id_device NUMBER) 
RETURN NUMBER 
IS
    res NUMBER :=0;
BEGIN
    FOR rec IN (SELECT price FROM Prix_Peripheral WHERE Prix_Peripheral.id = id_device) LOOP
        res := rec.price + res;
  END LOOP;
  RETURN res;
END;
/
CREATE OR REPLACE FUNCTION price_licence (id_device NUMBER) 
RETURN NUMBER 
IS
    res NUMBER :=0 ;
BEGIN
    FOR rec IN (SELECT price FROM Prix_Licence WHERE Prix_Licence.id = id_device) LOOP
        res := rec.price + res;
  END LOOP;
  RETURN res;
END;
/
CREATE OR REPLACE FUNCTION setup_price (id_device NUMBER)
RETURN NUMBER
IS 
    res NUMBER(10, 2) := 0;
BEGIN
    -- Récupération du prix de l'appareil
    BEGIN
        SELECT price INTO res FROM DEVICE WHERE id = id_device;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            res := 0;
    END;

    -- Ajout des coûts supplémentaires
    res := res + NVL(price_licence(id_device), 0) + NVL(price_peripheral(id_device), 0);
    
    RETURN res;
END;
/

CREATE OR REPLACE FUNCTION network_price (id_net NUMBER)
RETURN NUMBER
IS
    res NUMBER;
BEGIN
        FOR rec IN (SELECT id FROM DEVICE WHERE DEVICE.id_network = id_net) LOOP
        res := res + setup_price(rec.id);
        END LOOP;
        RETURN res;
END;
/