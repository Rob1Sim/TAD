
-- DROP INDEX IDX_USER_GROUP_GROUP;

-- DROP INDEX IDX_UGP_USER;

-- DROP INDEX IDX_UGP_GROUP;

-- DROP INDEX IDX_UGP_PERMISSION;


-- B-tree Index on the name of the GLPI_USER table (for the intervenors and users).
CREATE INDEX ind_user_name ON GLPI_USER(last_name ASC);

-- B-tree Index on the IP_address of the DEVICE table.
CREATE INDEX ind_device_ip ON DEVICE(ip_address ASC);

-- B-tree Index on the expiration_date of the LICENSE_DEVICE table.
CREATE INDEX ind_license_exp_date ON LICENCE_DEVICE(expiration_date ASC);

-- B-tree Index on the intervention date of the INTERVENTION table.
CREATE INDEX ind_intervention_date ON INTERVENTION(inter_date ASC);
