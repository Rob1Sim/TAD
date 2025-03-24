--====================
-- INDEX CREATION
--====================

-- B-tree Index on the name of the GLPI_USER table (for the intervenors and users).
CREATE INDEX ind_user_name ON GLPI_USER(name ASC);

-- B-tree Index on the IP_address of the DEVICE table.
CREATE INDEX ind_device_ip ON DEVICE(ip_address ASC);

-- B-tree Index on the expiration_date of the LICENSE_DEVICE table.
CREATE INDEX ind_license_exp_date ON LICENCE_DEVICE(expiration_date ASC);

-- B-tree Index on the intervention date of the INTERVENTION table.
CREATE INDEX ind_intervention_date ON INTERVENTION(inter_date ASC);

-- Indexes (B-tree par défaut)
-- User Group

CREATE INDEX IDX_USER_GROUP_USER ON USER_GROUP(id_user);
CREATE INDEX IDX_USER_GROUP_GROUP ON USER_GROUP(id_group);

-- User Group Permissions
CREATE INDEX IDX_UGP_USER ON USER_GROUP_PERMISSIONS(id_user);
CREATE INDEX IDX_UGP_GROUP ON USER_GROUP_PERMISSIONS(id_group);
CREATE INDEX IDX_UGP_PERMISSION ON USER_GROUP_PERMISSIONS(id_permission);
