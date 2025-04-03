SET SERVEROUTPUT ON;

DECLARE

BEGIN
    -- Test procedures
    DBMS_OUTPUT.PUT_LINE('Testing get_all_info_device');
    get_all_info_device(1);
    
    DBMS_OUTPUT.PUT_LINE('Testing get_all_network_infos');
    get_all_network_infos(1);
    
    DBMS_OUTPUT.PUT_LINE('Testing get_left_days_license');
    DBMS_OUTPUT.PUT_LINE('Days left for license: ' || get_left_days_license(1));
    
    DBMS_OUTPUT.PUT_LINE('Testing get_group_rights');
    get_group_rights(1);
    
    DBMS_OUTPUT.PUT_LINE('Testing get_user_rights');
    get_user_rights(1);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
