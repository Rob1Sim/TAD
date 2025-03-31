-- Procedure to describe a device 
-- it's peripherals, VMs, and it's license 
CREATE OR REPLACE PROCEDURE get_all_info_device(v_id_device NUMBER)
IS
    -- Cursor for the peripherals
    CURSOR cur_per IS
    SELECT id, description, type, price, buying_date 
    FROM PERIPHERAL 
    WHERE id_device = v_id_device;  -- do the join and filter
    v_per cur_per%ROWTYPE;

    -- Cursor for the VMs
    CURSOR cur_vm IS
    SELECT  id, description 
    FROM VM
    WHERE id_device = v_id_device;   -- do the join and filter
    v_vm cur_vm%ROWTYPE;

    -- variable for the license
    license LICENCE_DEVICE%ROWTYPE;
BEGIN
    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of peripherals related to the device id : ' || v_id_device);
    OPEN cur_per;   -- open cursor explicitly
    LOOP
        FETCH cur_per INTO v_per;   -- put the cursor value into v_per
        EXIT WHEN cur_per%NOTFOUND; -- exit condition when cursor is empty
        DBMS_OUTPUT.PUT_LINE('Peripheral - ID : ' || v_per.id ||
                            ', Description : ' || v_per.description ||
                            ', Type : ' || v_per.type ||
                             ', Price : ' || v_per.price ||
                             ', Buying Date : ' || TO_CHAR(v_per.buying_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE cur_per; -- close cursor

    -- Shows the related license
    SELECT ld.*
    INTO license 
    FROM LICENCE_DEVICE ld, DEVICE d    -- Affectation INTO license variable
    WHERE ld.id = d.id_licence_device
    AND d.id = v_id_device; -- filter on the device in the parameters

    DBMS_OUTPUT.PUT_LINE('License related to the device id : ' || v_id_device);
    DBMS_OUTPUT.PUT_LINE('License - ID : ' || license.id ||
                         ', Price : ' || license.price ||
                         ', Expiration Date : ' || TO_CHAR(license.expiration_date, 'YYYY-MM-DD') ||
                         ', Buying Date : ' || TO_CHAR(license.buying_date, 'YYYY-MM-DD'));

    -- Shows related VMs
    DBMS_OUTPUT.PUT_LINE('List of VMs related to the device id : ' || v_id_device);
    OPEN cur_vm;    -- open cursor explicitly
    LOOP
        FETCH cur_vm INTO v_vm; -- put the cursor value into v_vm
        EXIT WHEN cur_vm%NOTFOUND;  -- exit condition when cursor is empty
        DBMS_OUTPUT.PUT_LINE('VM - ID : ' || v_vm.id ||
                             ', Description : ' || v_vm.description);
    END LOOP;
    CLOSE cur_vm;  -- close cursor

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No data found for peripherals, license or VMs');
    
END get_all_info_device;
/




-- Procedure to describe a network 
--ALl the devices on the network and their IP addresses
--All the peripherals on the network
--ALl the VMs on a network
CREATE OR REPLACE PROCEDURE get_all_network_infos(v_id_network NUMBER)
IS
    -- Cursor for the devices
    CURSOR cur_dev IS
    SELECT id, description, type, price, ip_address, buying_date, guaranty_expiration_date 
    FROM DEVICE 
    WHERE id_network = v_id_network;
    v_dev cur_dev%ROWTYPE;

    -- Cursor for the peripherals
    CURSOR cur_per IS
    SELECT p.id, p.description, p.type, p.price, p.buying_date 
    FROM PERIPHERAL p, DEVICE d
    WHERE d.id = p.id_device
    AND d.id_network = v_id_network;
    v_per cur_per%ROWTYPE;

    -- Cursor for the VMs
    CURSOR cur_vm IS
    SELECT  vm.id, vm.description 
    FROM VM vm, DEVICE d
    WHERE d.id = vm.id_device
    AND d.id_network = v_id_network;
    v_vm cur_vm%ROWTYPE;

BEGIN
    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of device related to the network : ' || v_id_network);
    OPEN cur_dev;   -- open cursor explicitly
    LOOP
        FETCH cur_dev INTO v_dev;   -- put the cursor value into v_dev
        EXIT WHEN cur_dev%NOTFOUND; -- exit condition when cursor is empty
        DBMS_OUTPUT.PUT_LINE('Device - ID : ' || v_dev.id ||
                             ', Description : ' || v_dev.description ||
                             ', Type : ' || v_dev.type ||
                             ', Price : ' || v_dev.price ||
                             ', IP Address : ' || v_dev.ip_address ||
                             ', Buying Date : ' || TO_CHAR(v_dev.buying_date, 'YYYY-MM-DD') ||
                             ', Guaranty Expiration Date : ' || TO_CHAR(v_dev.guaranty_expiration_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE cur_dev; -- close cursor

    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of peripherals related to the network : ' || v_id_network);
    OPEN cur_per;   -- open cursor explicitly
    LOOP
        FETCH cur_per INTO v_per;   -- put the cursor value into v_per
        EXIT WHEN cur_per%NOTFOUND; -- exit condition when cursor is empty
        DBMS_OUTPUT.PUT_LINE('Peripheral - ID : ' || v_per.id ||
                             ', Description : ' || v_per.description ||
                             ', Type : ' || v_per.type ||
                             ', Price : ' || v_per.price ||
                             ', Buying Date : ' || TO_CHAR(v_per.buying_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE cur_per; -- close cursor

    -- Shows related VMs
    DBMS_OUTPUT.PUT_LINE('List of VMs related to the network : ' || v_id_network);
    OPEN cur_vm;    -- open cursor explicitly
    LOOP
        FETCH cur_vm INTO v_vm; -- put the cursor value into v_vm
        EXIT WHEN cur_vm%NOTFOUND;  -- exit condition when cursor is empty
        DBMS_OUTPUT.PUT_LINE('VM - ID : ' || v_vm.id ||
                             ', Description : ' || v_vm.description);
    END LOOP;
    CLOSE cur_vm;  -- close cursor

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No data found for peripherals, devices or VMs');
END get_all_network_infos;
/





-- Function that returns the number of days left to a license
-- can add exception
CREATE OR REPLACE FUNCTION get_left_days_license(
id_license NUMBER)
RETURN NUMBER
IS
    curr_date DATE; -- variable for the current date
    exp_date DATE;  -- variable for the expiration date
    days_left NUMBER(5,2);  -- returned value
BEGIN
    curr_date := SYSDATE;   -- getting current date
    SELECT expiration_date 
    INTO exp_date 
    FROM LICENCE_DEVICE ld -- getting the expiration date from the license's id
    WHERE ld.id = id_license;
    days_left := exp_date - curr_date; -- calculus for the number of days left, on Oracle we can just substract
    RETURN days_left;   -- return value

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'No license for this device');
END get_left_days_license;
/




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

    v_id_group GROUPS.ID%TYPE;
BEGIN
    SELECT id_group 
    INTO v_id_group 
    FROM USER_GROUP_PERMISSIONS -- gets the group id related to the user 
    WHERE id_user = v_id_user; 

    DBMS_OUTPUT.PUT_LINE('List of permissions for group related to the user : ' || v_id_user);
    get_group_rights(v_id_group); -- using previous procedure to show the permissions related to the group

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