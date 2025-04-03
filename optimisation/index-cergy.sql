@index-all.sql
--====================
-- INDEX CREATION
--====================
-- DROP INDEX ind_user_name;

-- DROP INDEX ind_device_ip;


-- DROP INDEX ind_license_exp_date;

-- DROP INDEX ind_intervention_date;

-- DROP INDEX IDX_USER_GROUP_USER;


CREATE INDEX IDX_USER_GROUP_USER ON USER_GROUP(id_user);
CREATE INDEX IDX_USER_GROUP_GROUP ON USER_GROUP(id_group);
 
 -- User Group Permissions
CREATE INDEX IDX_UGP_USER ON USER_GROUP_PERMISSIONS(id_user);
CREATE INDEX IDX_UGP_GROUP ON USER_GROUP_PERMISSIONS(id_group);
CREATE INDEX IDX_UGP_PERMISSION ON USER_GROUP_PERMISSIONS(id_permission);




