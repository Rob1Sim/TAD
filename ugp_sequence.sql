CREATE SEQUENCE user_group_permissions_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
CREATE OR REPLACE TRIGGER trg_user_group_permissions_id
    BEFORE INSERT ON USER_GROUP_PERMISSIONS
    FOR EACH ROW
BEGIN
    -- Attribuer une valeur unique à la colonne id avant l'insertion
    :NEW.id := user_group_permissions_seq.NEXTVAL;
END;
