
@description_functions.sql

-- Procedure that seeks all the rights for a group
CREATE OR REPLACE PROCEDURE get_group_rights(v_id_group NUMBER)
IS
    -- Cursor for the permissions
    CURSOR cur_perm IS
    SELECT p.name 
    FROM PERMISSIONS p, USER_GROUP_PERMISSIONS ugp
    WHERE p.id = ugp.id_permission
    AND ugp.id_group = v_id_group;
    v_perm cur_perm%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('List of permissions for group : ' || v_id_group);
    OPEN cur_perm;  -- open the cursor explicitly
    LOOP
        FETCH cur_perm INTO v_perm; --put the cursor value into v_item
        EXIT WHEN cur_perm%NOTFOUND;    -- exit condition when the cursor is empty
        DBMS_OUTPUT.PUT_LINE(' - ' || v_perm.name);
    END LOOP;
    CLOSE cur_perm; -- close cursor

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No permission for this group.');
END get_group_rights;
/




-- Procedure that seeks all the rights for a user (including the group ones)
CREATE OR REPLACE PROCEDURE get_user_rights(v_id_user NUMBER)
IS
    -- Cursor for the permissions
    CURSOR cur_perm IS
    SELECT p.name 
    FROM PERMISSIONS p, USER_GROUP_PERMISSIONS ugp
    WHERE p.id = ugp.id_permission
    AND ugp.id_user = v_id_user;
    v_perm cur_perm%ROWTYPE;
BEGIN

    DBMS_OUTPUT.PUT_LINE('List of permissions for group related to the user : ' || v_id_user);
        FOR rec IN ( SELECT id_group FROM USER_GROUP_PERMISSIONS WHERE id_user = v_id_user) LOOP
        get_group_rights(rec.id_group);
    END LOOP; -- using previous procedure to show the permissions related to the group

    DBMS_OUTPUT.PUT_LINE('List of permissions for the user : ' || v_id_user);
    OPEN cur_perm;  -- open the cursor explicitly
    LOOP
        FETCH cur_perm INTO v_perm; --put the cursor value into v_item
        EXIT WHEN cur_perm%NOTFOUND;    -- exit condition when the cursor is empty
        DBMS_OUTPUT.PUT_LINE(' - ' || v_perm.name);    -- print value
    END LOOP;
    CLOSE cur_perm; -- close cursor

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No permission for this user.');
END get_user_rights;
/