--Requête pour décrire un device (cf requête complexe device)
-- les périphériques, les licenses, les VM
CREATE OR REPLACE PROCEDURE get_all_info_device(    
id_device NUMBER)
IS
    CURSOR cur_per IS
    SELECT p.id, p.p_description, p.p_type, p.price, p.buying_date FROM PERIPHERAL p, DEVICE d
    WHERE d.id = p.id_device;
    v_per cur_perm%rowtype;

    CURSOR cur_vm IS
    SELECT  vm.id, vm.vm_description FROM VM vm, DEVICE d
    WHERE d.id = vm.id_device;
    v_vm cur_vm%rowtype;

    license LICENCE_DEVICE%rowtype;
BEGIN
    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of peripherals related to the device id : ' || id_device);
    OPEN cur_per;
    LOOP
        FETCH cur_per INTO v_per;
        EXIT WHEN cur_per%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_per);
    END LOOP;
    CLOSE(cur_per);

    -- Shows the related license
    SELECT ld.id, ld.price, ld.expiration_date, ld.buying_date INTO license FROM LICENCE_DEVICE ld, DEVICE d
    WHERE ld.id = d.id_licence_device;

    DBMS_OUTPUT.PUT_LINE('License related to the device id : ' || id_device);
    DBMS_OUTPUT.PUT_LINE(license);

    -- Shows related VMs
    DBMS_OUTPUT.PUT_LINE('List of VMs related to the device id : ' || id_device);
    OPEN cur_vm;
    LOOP
        FETCH cur_vm INTO v_vm;
        EXIT WHEN cur_vm%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_vm);
    END LOOP;
    CLOSE(cur_vm);
    
END get_all_info_device;/

--Requête pour décrire un réseau (cf requête complexe réseau, utilise la procédure device ci dessus)
--Sélectionner tous les devices sur un réseau et leur adresses IP.
--Sélectionner tous les périphériques sur un réseau.
--Sélectionner tous les VM d’un réseau.
CREATE OR REPLACE PROCEDURE get_all_network_infos(    
id_network NUMBER)
IS
    CURSOR cur_dev IS
    SELECT d.id, d.d_description, d.d_type, d.price, d.ip_address, d.buying_date, d.guaranty_expiration_date FROM DEVICE d, NETWORK net
    WHERE d.id_network = net.id;
    v_dev cur_dev%rowtype;

    CURSOR cur_per IS
    SELECT p.id, p.p_description, p.p_type, p.price, p.buying_date FROM PERIPHERAL p, DEVICE d, NETWORK net
    WHERE d.id = p.id_device
    AND d.id_network = net.id;
    v_per cur_perm%rowtype;

    CURSOR cur_vm IS
    SELECT  vm.id, vm.vm_description FROM VM vm, DEVICE d, NETWORK net
    WHERE d.id = vm.id_device
    AND d.id_network = net.id;
    v_vm cur_vm%rowtype;

BEGIN
    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of device related to the network : ' || id_network);
    OPEN cur_dev;
    LOOP
        FETCH cur_dev INTO v_dev;
        EXIT WHEN cur_dev%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_dev);
    END LOOP;
    CLOSE(cur_dev);

    -- Shows related peripherals
    DBMS_OUTPUT.PUT_LINE('List of peripherals related to the device id : ' || id_network);
    OPEN cur_per;
    LOOP
        FETCH cur_per INTO v_per;
        EXIT WHEN cur_per%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_per);
    END LOOP;
    CLOSE(cur_per);

    -- Shows related VMs
    DBMS_OUTPUT.PUT_LINE('List of VMs related to the device id : ' || id_network);
    OPEN cur_vm;
    LOOP
        FETCH cur_vm INTO v_vm;
        EXIT WHEN cur_vm%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_vm);
    END LOOP;
    CLOSE(cur_vm);
END get_all_network_infos;/





--nombre de jour qui reste pour une licence
CREATE OR REPLACE FUNCTION get_left_days_license(
id_license NUMBER)
RETURN NUMBER;
IS
    curr_date DATE;
    exp_date DATE;
    days_left (5,2);
BEGIN
    curr_date := SYSDATE;   -- getting current date
    SELECT expiration_date INTO exp_date FROM LICENCE_DEVICE ld -- getting the expiration date from the license's id
    WHERE ld.id = id_license;
    days_left := exp_date - curr_date; -- calculus for the number of days left
    RETURN days_left;
END get_left_days_license;/




--Rechercher tous les droits d’un group
CREATE OR REPLACE PROCEDURE get_group_rights(
id_group NUMBER)
IS
    CURSOR cur_perm IS
    SELECT p.perm_name FROM PERMISSIONS p, USER_GROUP_PERMISSIONS ugp, GROUPS g
    WHERE p.id = ugp.id_permission
    AND p.id_group = g.id;
    v_item cur_perm%rowtype;
BEGIN
    DBMS_OUTPUT.PUT_LINE('List of permissions for group : ' || id_group);
    OPEN cur_perm;
    LOOP
        FETCH cur_perm INTO v_item;
        EXIT WHEN cur_perm%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_items ||',');
    END LOOP;
    CLOSE cur_perm;
END get_group_rights;/


--Rechercher tous les droits d’un user
CREATE OR REPLACE PROCEDURE get_user_rights(
id_user NUMBER)
IS
    CURSOR cur_perm IS
    SELECT p.perm_name FROM PERMISSIONS p, USER_GROUP_PERMISSIONS ugp, GLPI_USER gu
    WHERE p.id = ugp.id_permission
    AND g.id_user = gu.id;
    v_item cur_perm%rowtype;
    id_group GROUPS%id;
BEGIN
    SELECT g.id_group INTO id_group FROM USER_GROUP g, GLPI_USER gu -- gets the group id related to the user 
    WHERE g.id_user = gu.id; 

    DBMS_OUTPUT.PUT_LINE('List of permissions for group related to the user : ' || id_group);
    get_group_rights(); -- using previous procedure

    DBMS_OUTPUT.PUT_LINE('List of permissions for the user : ' || id_group);
    OPEN cur_perm;
    LOOP
        FETCH cur_perm INTO v_item;
        EXIT WHEN cur_perm%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_items ||',');
    END LOOP;
    CLOSE cur_perm;
END get_group_rights;/



