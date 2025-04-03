CREATE OR REPLACE VIEW Prix_Device AS
SELECT id, price, buying_date
FROM DEVICE;

CREATE OR REPLACE VIEW Prix_Intervention AS
SELECT id, price, inter_date
FROM INTERVENTION;

CREATE OR REPLACE VIEW Prix_Peripheral AS
SELECT id, price, buying_date
FROM PERIPHERAL;

CREATE OR REPLACE VIEW Prix_Licence AS
SELECT id, price, buying_date
FROM LICENCE_DEVICE;

COMMIT;
--