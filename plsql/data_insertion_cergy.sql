
@data_insertion.sql
BEGIN
        -- Insertion de groupes
    FOR i IN 1..5 LOOP
        INSERT INTO GROUPS (id, name)
        VALUES (
            i,
            'Groupe_' || i
        );
    END LOOP;

    -- Insertion de permissions
    FOR i IN 1..5 LOOP
        INSERT INTO PERMISSIONS (id, name)
        VALUES (
            i,
            'Permission_' || i
        );
    END LOOP;
END;