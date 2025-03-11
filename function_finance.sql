CREATE VIEW Prix_Device AS
SELECT id, price, buying_date
FROM DEVICE;

CREATE VIEW Prix_Intervention AS
SELECT id, price, buying_date
FROM INTERVENTION;

CREATE VIEW Prix_Peripheral AS
SELECT id, price, buying_date
FROM PERIPHERAL;

CREATE VIEW Prix_Licence AS
SELECT id, price, buying_date
FROM LICENCE_DEVICE;

CREATE OR REPLACE FUNCTION price_ticket (id_ticket NUMBER) 
RETURN NUMBER 
IS
    res NUMBER;
    CURSOR curs IS 
    SELECT price FROM Prix_Intervention
    WHERE Prix_Intervention.id = id_ticket;
    temp price%rowtype;
BEGIN
    OPEN cur_clients;
    LOOP
        FETCH cur_clients INTO temp;
        EXIT WHEN cur_clients%NOTFOUND;
        res := res + temp;
    END LOOP;
    CLOSE cur_clients;

  RETURN res;
END;

CREATE OR REPLACE FUNCTION price_peripheral (id_device NUMBER) 
RETURN NUMBER 
IS
    res NUMBER;
BEGIN
    FOR rec IN (SELECT price FROM Prix_Peripheral WHERE Prix_Peripheral.id = id_device) LOOP
        res := rec + res;
  END LOOP;
  RETURN res;
END;

CREATE OR REPLACE FUNCTION price_licence (id_device NUMBER) 
RETURN NUMBER 
IS
    res NUMBER;
BEGIN
    FOR rec IN (SELECT price FROM Prix_Licence WHERE Prix_Licence.id = id_device) LOOP
        res := rec + res;
  END LOOP;
  RETURN res;
END;

CREATE OR REPLACE FUNCTION setup_price (id_device NUMBER)
RETURN NUMBER
IS 
    res NUMBER;
BEGIN
    res := price_licence(id_device) + price_peripheral(id_device) + (SELECT price FROM DEVICE WHERE DEVICE.id = id_device;)
    RETURN res;
END;

CREATE OR REPLACE FUNCTION network_price (id_net NUMBER)
RETURN NUMBER
IS
    res NUMBER;
BEGIN
        FOR rec IN (SELECT id FROM DEVICE WHERE DEVICE.id_network = id_net) LOOP
        res := res + setup_price(rex);
        END LOOP;
        RETURN res;
END