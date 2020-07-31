-- 2.7.6 start

-- adminservice start

alter table `sys_open_api` add column `api_status` tinyint not null default 1 comment '0 - 冻结，1-正常';
alter table `sys_backend_service` add column `service_status` tinyint not null default 1 comment '0 - 冻结，1-正常';

-- 设置
alter table `sys_backend_service` add column `service_type` tinyint not null default 2 comment '0-系统预留api, 1-系统默认api, 2-用户创建api';
-- 设置系统调用api服务类型为0
update `sys_backend_service` set service_type=0 where match_path like '%sysmgr%';
update `sys_backend_service` set service_type=0 where match_path in ('/updateUserPassword/**');
-- 设置默认api服务类型为1
update `sys_backend_service` set service_type=1 where match_path in ('/logout/**', '/updatePassword/**', '/iam/users/**');

-- 移除默认角色
set @sys_mgr_role_id=(select role_id from sys_role where role_code='sysmgr');
set @default_role_id=(select role_id from sys_role where role_code='default_role');
delete from sys_role where role_id in (@sys_mgr_role_id, @default_role_id);
delete from sys_role_permission where role_id in (@sys_mgr_role_id, @default_role_id);

-- 删除旧版本废弃的api
delete from sys_resource where resource_code='admin-service-base-api' or parent_code='admin-service-base-api';
delete from sys_resource where resource_code='default-api' or parent_code='default-api';

-- 更新网关url
update sys_resource set url='apply-list' where resource_code='app_message';
update sys_resource set url='api-list' where resource_code='service_register';

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`service_type`, `created_by`, `created_time`, `modified_by`, `modified_time`) values
('app_message', '/sysmgr/sysExternalApp/**', '*', null, 1, 'sys_external_app', 0, 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`service_type`, `created_by`, `created_time`, `modified_by`, `modified_time`) values
('app_message', '/sysmgr/sysExternalAppPermission/**', '*', null, 1, 'sys_external_app_permission', 0, 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`service_type`, `created_by`, `created_time`, `modified_by`, `modified_time`) values
('api-list', '/sysmgr/sysOpenApi/**', '*', null, 1, 'sys_open_api', 0, 0, now(), null, null);
-- adminservice finish

-- ----------------------------
-- Table structure for telepg_inst_param
-- ----------------------------
DROP TABLE IF EXISTS `telepg_inst_param`;
CREATE TABLE `telepg_inst_param`  (
  `pg_inst_param_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `name` varchar(128) DEFAULT NULL COMMENT '参数名称',
  `constrain` tinyint(4) NOT NULL DEFAULT '0' COMMENT '参数限制,0是没限制,1是限定值,2不可修改,3不可见',
  `candidates` varchar(1024) NULL  DEFAULT NULL COMMENT '限定值,多值用|隔开',
  `create_timestamp` datetime NULL COMMENT '创建时间',
  `update_timestamp` datetime NULL COMMENT '修改时间',
  `version` varchar(255) DEFAULT NULL COMMENT '对应param_type的版本号',
  PRIMARY KEY (`pg_inst_param_id`) USING BTREE,
  KEY `idx_version` (`version`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pg_inst_param
-- ----------------------------
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('listen_addresses', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('application_name', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('config_file', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('data_directory', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('hba_file', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('ident_file', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('external_pid_file', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('client_encoding', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('port', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('unix_socket_directories', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('unix_socket_group', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('unix_socket_permissions', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('bonjour', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('bonjour_name', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('password_encryption', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('wal_log_hints', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('wal_consistency_checking', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('archive_mode', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('archive_command', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('archive_cleanup_command', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('archive_timeout', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('synchronous_standby_names', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('primary_conninfo', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('primary_slot_name', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('promote_trigger_file', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_destination', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('logging_collector', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_directory', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_filename', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_file_mode', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_truncate_on_rotation', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_rotation_age', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('syslog_facility', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('syslog_ident', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('syslog_sequence_numbers', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('syslog_split_messages', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('event_source', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_transaction_sample_rate', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_line_prefix', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('log_timezone', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('cluster_name', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('timezone', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('timezone_abbreviations', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('default_text_search_config', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('shared_preload_libraries', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('local_preload_libraries', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('session_preload_libraries', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('dynamic_library_path', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('include_dir', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('include_if_exists', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('include', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_end_command', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_min_apply_delay', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_action', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_inclusive', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_lsn', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_name', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_time', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_timeline', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('recovery_target_xid', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('restore_command', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('jit_provider', 2,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('default_table_access_method', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('default_tablespace', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('transaction_deferrable', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('transaction_isolation', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('transaction_read_only', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('krb_server_keyfile', 3,'12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('DateStyle', 1, 'ISO, DMY|ISO, MDY|ISO, YMD|Postgres, DMY|Postgres, MDY|Postgres, YMD|SQL, DMY|SQL, MDY|SQL, YMD', '12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('default_transaction_isolation', 1, 'serializable|repeatable read|read committed|read uncommitted', '12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('lc_messages', 1, 'C|POSIX|ar_AE|ar_BH|ar_DZ|ar_EG|ar_IN|ar_IQ|ar_JO|ar_KW|ar_LB|ar_LY|ar_MA|ar_OM|ar_QA|ar_SA|ar_SD|ar_SY|ar_TN|ar_YE|be_BY|bg_BG|ca_ES|cs_CZ|da_DK|de_AT|de_BE|de_CH|de_DE|de_LU|el_GR|en_AU|en_CA|en_GB|en_IN|en_NZ|en_PH|en_US|en_ZA|en_ZW|es_AR|es_BO|es_CL|es_CO|es_CR|es_DO|es_EC|es_ES|es_GT|es_HN|es_MX|es_NI|es_PA|es_PE|es_PR|es_PY|es_SV|es_US|es_UY|es_VE|et_EE|eu_ES|fi_FI|fo_FO|fr_BE|fr_CA|fr_CH|fr_FR|fr_LU|gl_ES|gu_IN|he_IL|hi_IN|hr_HR|hu_HU|id_ID|is_IS|it_CH|it_IT|ja_JP|ko_KR|lt_LT|lv_LV|mk_MK|mn_MN|ms_MY|nb_NO|nl_BE|nl_NL|no_NO|pl_PL|pt_BR|pt_PT|ro_RO|ru_RU|ru_UA|sk_SK|sl_SI|sq_AL|sr_RS|sv_FI|sv_SE|ta_IN|te_IN|th_TH|tr_TR|uk_UA|ur_PK|vi_VN|zh_CN|zh_HK|zh_TW', '12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('lc_monetary', 1, 'C|POSIX|ar_AE|ar_BH|ar_DZ|ar_EG|ar_IN|ar_IQ|ar_JO|ar_KW|ar_LB|ar_LY|ar_MA|ar_OM|ar_QA|ar_SA|ar_SD|ar_SY|ar_TN|ar_YE|be_BY|bg_BG|ca_ES|cs_CZ|da_DK|de_AT|de_BE|de_CH|de_DE|de_LU|el_GR|en_AU|en_CA|en_GB|en_IN|en_NZ|en_PH|en_US|en_ZA|en_ZW|es_AR|es_BO|es_CL|es_CO|es_CR|es_DO|es_EC|es_ES|es_GT|es_HN|es_MX|es_NI|es_PA|es_PE|es_PR|es_PY|es_SV|es_US|es_UY|es_VE|et_EE|eu_ES|fi_FI|fo_FO|fr_BE|fr_CA|fr_CH|fr_FR|fr_LU|gl_ES|gu_IN|he_IL|hi_IN|hr_HR|hu_HU|id_ID|is_IS|it_CH|it_IT|ja_JP|ko_KR|lt_LT|lv_LV|mk_MK|mn_MN|ms_MY|nb_NO|nl_BE|nl_NL|no_NO|pl_PL|pt_BR|pt_PT|ro_RO|ru_RU|ru_UA|sk_SK|sl_SI|sq_AL|sr_RS|sv_FI|sv_SE|ta_IN|te_IN|th_TH|tr_TR|uk_UA|ur_PK|vi_VN|zh_CN|zh_HK|zh_TW', '12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('lc_numeric', 1, 'C|POSIX|ar_AE|ar_BH|ar_DZ|ar_EG|ar_IN|ar_IQ|ar_JO|ar_KW|ar_LB|ar_LY|ar_MA|ar_OM|ar_QA|ar_SA|ar_SD|ar_SY|ar_TN|ar_YE|be_BY|bg_BG|ca_ES|cs_CZ|da_DK|de_AT|de_BE|de_CH|de_DE|de_LU|el_GR|en_AU|en_CA|en_GB|en_IN|en_NZ|en_PH|en_US|en_ZA|en_ZW|es_AR|es_BO|es_CL|es_CO|es_CR|es_DO|es_EC|es_ES|es_GT|es_HN|es_MX|es_NI|es_PA|es_PE|es_PR|es_PY|es_SV|es_US|es_UY|es_VE|et_EE|eu_ES|fi_FI|fo_FO|fr_BE|fr_CA|fr_CH|fr_FR|fr_LU|gl_ES|gu_IN|he_IL|hi_IN|hr_HR|hu_HU|id_ID|is_IS|it_CH|it_IT|ja_JP|ko_KR|lt_LT|lv_LV|mk_MK|mn_MN|ms_MY|nb_NO|nl_BE|nl_NL|no_NO|pl_PL|pt_BR|pt_PT|ro_RO|ru_RU|ru_UA|sk_SK|sl_SI|sq_AL|sr_RS|sv_FI|sv_SE|ta_IN|te_IN|th_TH|tr_TR|uk_UA|ur_PK|vi_VN|zh_CN|zh_HK|zh_TW', '12', now(), now());
INSERT INTO `telepg_inst_param`(`name`, `constrain`, `candidates`, `version` , `create_timestamp` , `update_timestamp`) VALUES ('lc_time', 1, 'C|POSIX|ar_AE|ar_BH|ar_DZ|ar_EG|ar_IN|ar_IQ|ar_JO|ar_KW|ar_LB|ar_LY|ar_MA|ar_OM|ar_QA|ar_SA|ar_SD|ar_SY|ar_TN|ar_YE|be_BY|bg_BG|ca_ES|cs_CZ|da_DK|de_AT|de_BE|de_CH|de_DE|de_LU|el_GR|en_AU|en_CA|en_GB|en_IN|en_NZ|en_PH|en_US|en_ZA|en_ZW|es_AR|es_BO|es_CL|es_CO|es_CR|es_DO|es_EC|es_ES|es_GT|es_HN|es_MX|es_NI|es_PA|es_PE|es_PR|es_PY|es_SV|es_US|es_UY|es_VE|et_EE|eu_ES|fi_FI|fo_FO|fr_BE|fr_CA|fr_CH|fr_FR|fr_LU|gl_ES|gu_IN|he_IL|hi_IN|hr_HR|hu_HU|id_ID|is_IS|it_CH|it_IT|ja_JP|ko_KR|lt_LT|lv_LV|mk_MK|mn_MN|ms_MY|nb_NO|nl_BE|nl_NL|no_NO|pl_PL|pt_BR|pt_PT|ro_RO|ru_RU|ru_UA|sk_SK|sl_SI|sq_AL|sr_RS|sv_FI|sv_SE|ta_IN|te_IN|th_TH|tr_TR|uk_UA|ur_PK|vi_VN|zh_CN|zh_HK|zh_TW', '12', now(), now());	
 
-- ----------------------------
-- Table structure for telepg_inst_param_history
-- ----------------------------
DROP TABLE IF EXISTS `telepg_inst_param_history`;
CREATE TABLE `telepg_inst_param_history`  (
  `pg_inst_param_history_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '修改参数历史ID',
  `name` varchar(128) DEFAULT NULL COMMENT '参数名称',
  `value_before` varchar(128) DEFAULT NULL COMMENT '原来的值',
  `value_after` varchar(128) DEFAULT NULL COMMENT '修改后的值',
  `create_timestamp` datetime NULL COMMENT '创建时间',
  `update_timestamp` datetime NULL COMMENT '修改时间',
  `check_apply` boolean DEFAULT  false COMMENT '检查是否生效，用于需要重启的参数',
  `error_msg` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '错误信息',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户ID',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  PRIMARY KEY (`pg_inst_param_history_id`) USING BTREE,
  KEY `idx_tenant_inst` (`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

update telepg_spec set spec_desc='单机' where spec_desc='单节点';
update telepg_spec set spec_desc='一主一备' where spec_desc='1主1从';
update telepg_spec set spec_desc='一主两备' where spec_desc='1主2从';

DROP TABLE IF EXISTS `telepg_pub_program_version`;
CREATE TABLE `telepg_pub_program_version` (
  `version_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '版本标识',
  `version_time` datetime NOT NULL,
  `version_num` varchar(32) NOT NULL COMMENT '版本号',
  `category` varchar(32) NOT NULL COMMENT '应用分类标识',
  `upload_path` varchar(500) NOT NULL COMMENT '上传路径',
  `upload_time` datetime NOT NULL COMMENT '上传日期',
  `upload_by` bigint(20)  COMMENT '上传者',
  `upload_name` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '0-无效  1-有效',
  `size` double DEFAULT '0' COMMENT '文件大小，单位：M',
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='应用程序版本表';


alter table telepg_inst add column  `inst_type` tinyint COMMENT '实例类型,1单节点,2一主一备,3一主两备' after update_timestamp;
update telepg_inst a inner join (select pg_inst_id , count(1) c from telepg_node  group by pg_inst_id ) b  on a.pg_inst_id= b.pg_inst_id set a.inst_type = b.c;

-- 将telepg_spec的spec_desc列移到telepg_inst表上
alter table telepg_inst add column  `inst_type_desc` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例类型描述' after inst_type;
update telepg_inst a inner join telepg_spec b  on a.pg_inst_id= b.pg_inst_id set a.inst_type_desc = b.spec_desc;
ALTER TABLE telepg_spec DROP COLUMN `spec_desc` ;

DROP TABLE IF EXISTS `telepg_backup_server`;
CREATE TABLE `telepg_backup_server` (
  `pg_backup_server_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务标识',
  `pg_host_id` bigint(20) DEFAULT NULL COMMENT 'PGSQL服务器标识',
  `name` varchar(256) DEFAULT NULL COMMENT '备机名称',
  `install_path` varchar(256) NOT NULL COMMENT '安装路径',
  `data_path` varchar(256) NOT NULL COMMENT '数据路径',
  `service_port` int(11) NOT NULL COMMENT '服务端口',
  `version` varchar(256) NOT NULL COMMENT '版本信息',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户标识',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户标识',
  `create_timestamp` datetime DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime DEFAULT NULL COMMENT '更新时间',
  `zk_path` varchar(256) NOT NULL COMMENT '备份服务节点的zookeeper路径',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_backup_server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

DROP TABLE IF EXISTS `telepg_backup_server_inst_rel`;
CREATE TABLE `telepg_backup_server_inst_rel` (
  `rel_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联关系表',
  `pg_backup_server_id` bigint(20) NOT NULL COMMENT 'PGSQL服务标识',
  `pg_inst_id` varchar(64) DEFAULT NULL COMMENT '绑定的PG实例id',
  PRIMARY KEY (`rel_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

DROP TABLE IF EXISTS `telepg_backup_base_info`;
CREATE TABLE `telepg_backup_base_info` (
  `pg_backup_base_info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '全量备份信息标识',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户标识',
  `pg_inst_id` varchar(64) NOT NULL COMMENT '产品实例标识',
  `backup_id` varchar(64) DEFAULT NULL COMMENT '备份标识',
  `backup_type` tinyint(4) DEFAULT NULL COMMENT '备份类型 0-自动 1-手动',
  `backup_label` varchar(64) DEFAULT NULL COMMENT '备份标签',
  `backup_name` varchar(64) DEFAULT NULL COMMENT '备份名称',
  `begin_time` datetime DEFAULT NULL COMMENT '备份开始时间',
  `begin_wal` varchar(64) DEFAULT NULL COMMENT '备份起始的wal文件',
  `begin_offset` bigint(20) DEFAULT NULL COMMENT '备份起始的wal文件的LSN偏移量',
  `begin_xlog` varchar(64) DEFAULT NULL COMMENT '备份起始的xlog位置',
  `end_time` datetime DEFAULT NULL COMMENT '备份结束时间',
  `end_wal` varchar(64) DEFAULT NULL COMMENT '备份结束时的wal文件',
  `end_offset` bigint(20) DEFAULT NULL COMMENT '备份结束的wal文件的LSN偏移量',
  `end_xlog` varchar(64) DEFAULT NULL COMMENT '备份结束的xlog位置',
  `total_time` int(10) DEFAULT '0' COMMENT '总的备份时间，单位:秒',
  `backup_size` bigint(64) DEFAULT '0' COMMENT '总的备份大小，单位:B',
  `backup_deduplicated_size` bigint(64) DEFAULT '0' COMMENT '表空间的大小，单位:B',
  `system_id` varchar(128) DEFAULT NULL COMMENT 'PG实例的唯一标识',
  `version` varchar(64) DEFAULT NULL COMMENT 'PG实例的版本号',
  `timeline` varchar(64) DEFAULT NULL COMMENT 'PG实例的时间线',
  `xlog_segment_size` bigint(64) DEFAULT NULL COMMENT 'PG实例的单个wal文件大小，单位B',
  `pgdata` varchar(256) DEFAULT NULL COMMENT 'PG实例的数据目录',
  `config_file` varchar(256) DEFAULT NULL COMMENT 'PG实例配置文件postgresql.conf的路径',
  `hba_file` varchar(256) DEFAULT NULL COMMENT 'PG实例配置文件pg_hba.conf的路径',
  `ident_file` varchar(256) DEFAULT NULL COMMENT 'PG实例配置文件pg_ident.conf的路径',
  `included_files` text COMMENT 'PG实例的其他引用的配置文件路径集合,用逗号分割',
  `tablespaces` text COMMENT 'PG实例的表空间,用jsonb标识，例如：[(''myspace'', 16434, ''/home/udal/postgresql/myspace)]',
  `backup_path` varchar(256) DEFAULT NULL COMMENT '全量备份的文件路径',
  `status` tinyint(4) DEFAULT NULL COMMENT '备份状态 0-开始 1-运行 2-完成 -1-异常',
  `error` varchar(1024) DEFAULT NULL COMMENT '备份异常信息',
  `remark` varchar(1024) DEFAULT NULL COMMENT '描述信息',
  PRIMARY KEY (`pg_backup_base_info_id`) USING BTREE,
  KEY `idx_tenant_inst` (`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

DROP TABLE IF EXISTS `telepg_backup_settting`;
CREATE TABLE `telepg_backup_settting` (
  `pg_backup_settting_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '备份配置标识',
  `pg_inst_id` varchar(64) NOT NULL COMMENT '产品实例标识',
  `enable` tinyint(1) DEFAULT NULL COMMENT '是否开启备份的开关 0-禁止 1- 开启',
  `minimum_redundancy` int(10) DEFAULT '0' COMMENT '至少需要冗余的份数',
  `auto_wal` tinyint(1) DEFAULT '0' COMMENT '是否开启增量备份的开关 0-禁止 1- 开启',
  `base_retain_day` int(10) DEFAULT NULL COMMENT '全量备份保留天数',
  `wal_retain_day` int(10) DEFAULT NULL COMMENT '增量备份保留天数',
  `start_time` varchar(32) DEFAULT NULL COMMENT '备份开始时间 一般选取业务低峰期 比如说凌晨1点半 输入1:30',
  `day_of_weeks` varchar(256) DEFAULT NULL COMMENT '备份周期(建议一周至少备份2次) 例如：1，2，3，4，5，6，7',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_backup_settting_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

DROP TABLE IF EXISTS `telepg_backup_task_info`;
CREATE TABLE `telepg_backup_task_info` (
  `pg_backup_task_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务标识',
  `pg_backup_server_id` bigint(20) DEFAULT NULL COMMENT '备机标识',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户标识',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户标识',
  `pg_inst_id` varchar(64) DEFAULT NULL COMMENT '产品实例标识',
  `pg_backup_base_info_id` bigint(20) DEFAULT NULL COMMENT '全量备份标识',
  `oper_type` tinyint(4) DEFAULT NULL COMMENT '操作类型 0-backup(调用即时备份) 1-copy(复制备份) 2-delete(删除备份) 3-recovery(恢复备份)',
  `status` tinyint(4) DEFAULT NULL COMMENT '任务状态 0-开始 1-运行 2-完成 -1-异常',
  `status_desc` varchar(256) DEFAULT NULL COMMENT '任务状态描述',
  `error` varchar(1024) DEFAULT NULL COMMENT '备份异常信息',
  `create_timestamp` datetime DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime DEFAULT NULL COMMENT '修改时间',
  `params` text COMMENT '调用的参数,格式:json',
  PRIMARY KEY (`pg_backup_task_id`) USING BTREE,
  KEY `idx_tenant_inst` (`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- 新增菜单权限
INSERT INTO `sys_resource`(`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`, `modified_by`, `modified_time`) VALUES (100004, 'pgMonitor', '', '监控', 1, 'PostgreSQL', NULL, NULL, 'pgMonitor', '_self', 1, 1, 1, '', 1, '2020-05-21 15:16:52', NULL, '2020-05-21 15:19:19');
INSERT INTO `sys_resource`(`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`, `modified_by`, `modified_time`) VALUES (100006, 'engineMonitor', '', '引擎监控', 1, 'pgMonitor', 100004, '100004', 'engineMonitor', '_self', 1, 1, 2, '', 1, '2020-05-21 15:20:18', 1, '2020-05-21 07:32:57');
INSERT INTO `sys_resource`(`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`, `modified_by`, `modified_time`) VALUES (100007, 'logMonitor', '', '日志监控', 1, 'pgMonitor', 100004, '100004', 'logMonitor', '_self', 1, 1, 3, '', 1, '2020-05-21 15:20:31', 1, '2020-05-21 07:33:02');
INSERT INTO `sys_resource`(`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`, `modified_by`, `modified_time`) VALUES (100008, 'resourceMonitor', '', '资源监控', 1, 'pgMonitor', 100004, '100004', 'resourceMonitor', '_self', 1, 1, 1, '', 1, '2020-05-21 15:32:17', NULL, '2020-05-21 15:32:17');
INSERT INTO `sys_resource`(`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`, `modified_by`, `modified_time`) VALUES (100009, 'helpCenter', '', '帮助中心', 1, 'PostgreSQL', 100001, '100001', 'helpCenter', '_self', 1, 1, 9, '', 1, '2020-06-08 09:43:22', NULL, '2020-06-08 09:43:22');

INSERT INTO `sys_role_permission`(`role_resource_id`, `role_id`, `resource_id`, `created_by`, `created_time`, `modified_time`, `status`) VALUES (36, 3, 100004, 1, '2020-06-08 09:44:58', '2020-06-08 09:44:58', 1);
INSERT INTO `sys_role_permission`(`role_resource_id`, `role_id`, `resource_id`, `created_by`, `created_time`, `modified_time`, `status`) VALUES (37, 3, 100008, 1, '2020-06-08 09:44:58', '2020-06-08 09:44:58', 1);
INSERT INTO `sys_role_permission`(`role_resource_id`, `role_id`, `resource_id`, `created_by`, `created_time`, `modified_time`, `status`) VALUES (38, 3, 100006, 1, '2020-06-08 09:44:58', '2020-06-08 09:44:58', 1);
INSERT INTO `sys_role_permission`(`role_resource_id`, `role_id`, `resource_id`, `created_by`, `created_time`, `modified_time`, `status`) VALUES (39, 3, 100007, 1, '2020-06-08 09:44:58', '2020-06-08 09:44:58', 1);
INSERT INTO `sys_role_permission`(`role_resource_id`, `role_id`, `resource_id`, `created_by`, `created_time`, `modified_time`, `status`) VALUES (41, 3, 100009, 1, '2020-06-08 09:44:58', '2020-06-08 09:44:58', 1);


DROP TABLE IF EXISTS `telepg_stat_cpu_usage`;
CREATE TABLE `telepg_stat_cpu_usage` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `user_percent` FLOAT NULL COMMENT 'cpu user time百分比,如：99.99',
    `sys_percent` FLOAT NULL COMMENT 'cpu sys time百分比,如：99.99',
    `nice_percent` FLOAT NULL COMMENT 'cpu nice time百分比,如：99.99',
    `idle_percent` FLOAT NULL COMMENT 'cpu idle time百分比,如：99.99',
    `iowait_percent` FLOAT NULL COMMENT 'cpu iowait time 百分比,如：99.99',
    `collect_interval` INT NULL COMMENT '采集周期(秒)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_memory`;
CREATE TABLE `telepg_stat_memory` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `total` BIGINT NULL COMMENT '内存总量(字节)',
    `used` BIGINT NULL COMMENT '内存已使用(字节)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_disk_io`;
CREATE TABLE `telepg_stat_disk_io` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `read_count` INT NULL COMMENT '周期内读磁盘次数',
    `write_count` INT NULL COMMENT '周期内写磁盘次数',
    `read_bytes` BIGINT NULL COMMENT '周期内读磁盘字节数',
    `write_bytes` BIGINT NULL COMMENT '周期内写磁盘字节数',
    `util_percent` FLOAT NULL COMMENT 'util%,如：99.99',
    `collect_interval` INT NULL COMMENT '采集周期(秒)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_disk_usage`;
CREATE TABLE `telepg_stat_disk_usage` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `total_bytes` BIGINT NULL COMMENT '数据盘总容量（字节）',
    `available_bytes` BIGINT NULL COMMENT '数据盘可用容量（字节）',
    `used_bytes` BIGINT NULL COMMENT '数据盘已使用容量（字节）',
    `collect_time` DATETIME NULL COMMENT '记录采集时间'
);

DROP TABLE IF EXISTS `telepg_stat_net_io`;
CREATE TABLE `telepg_stat_net_io` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `in_bytes` BIGINT NULL COMMENT '周期内输入字节数',
    `out_bytes` BIGINT NULL COMMENT '周期内输出字节数',
    `collect_interval` INT NULL COMMENT '采集周期(秒)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_node`;
CREATE TABLE `telepg_stat_node` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `role` TINYINT NULL COMMENT '节点角色：0 primary node,1 standby node,2 unkown node(连不上)',
    `replay_lag` INT ( 255 ) NULL COMMENT '重放延迟时间(毫秒)',
    `alive` boolean NULL COMMENT '进程是否存活',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time` (`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_stmts`;
CREATE TABLE `telepg_stat_stmts` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `total` INT NULL COMMENT '周期内执行的语句总数',
    `mean_time` INT NULL COMMENT '周期内语句平均耗时',
    `collect_interval` INT NULL COMMENT '采集周期(秒)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time` (`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_transaction`;
CREATE TABLE `telepg_stat_transaction` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `total` INT NULL COMMENT '周期内执行的总事务数',
    `commit_count` INT NULL COMMENT '周期内提交的事务数',
    `rollback_count` INT NULL COMMENT '周期内回滚的事务数',
    `deadlocks` INT NULL COMMENT '周期内产生的死锁数',
    `collect_interval` INT NULL COMMENT '采集周期(秒)',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time` (`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_slow_query`;
CREATE TABLE `telepg_stat_slow_query` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `db_name` VARCHAR ( 64 ) NULL COMMENT '数据库名',
    `user_name` VARCHAR ( 64 ) NULL COMMENT '用户名',
    `pid` INT NULL COMMENT '进程ID',
    `app_name` VARCHAR ( 64 ) NULL COMMENT '应用程序名',
    `client_addr` VARCHAR ( 64 ) NULL COMMENT '客户端地址',
    `client_port` INT NULL COMMENT '客户端端口',
    `query_start` DATETIME NULL COMMENT 'Query开始时间',
    `query_end` DATETIME NULL COMMENT 'Query结束时间',
    `query` VARCHAR ( 1000 ) NULL COMMENT '执行的语句',
    `cmd_type` VARCHAR ( 64 ) NULL COMMENT '命令类型',
    `query_cost` INT NULL COMMENT '语句耗时（毫秒）',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time_tenant_inst_node` (`collect_time`, `tenant_id`,`pg_inst_id`,`pg_node_id` )
);

DROP TABLE IF EXISTS `telepg_stat_connection`;
CREATE TABLE `telepg_stat_connection` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `total` INT NULL COMMENT 'PG连接数',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time` (`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_err_log`;
CREATE TABLE `telepg_stat_err_log` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_node_id` BIGINT NULL COMMENT '节点ID',
    `log_time` DATETIME NULL COMMENT '日志打印时间',
    `pid` INT NULL COMMENT '进程ID',
    `level` VARCHAR ( 64 ) NULL COMMENT '日志级别',
    `message` VARCHAR ( 1000 ) NULL COMMENT '日志内容',
    `log_file` VARCHAR ( 1024 ) NULL COMMENT '日志文件',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_node_time` (`pg_node_id`,`collect_time`),
    KEY `idx_time` (`collect_time`)
);

DROP TABLE IF EXISTS `telepg_stat_gw_node`;
CREATE TABLE `telepg_stat_gw_node` (
    `id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    `tenant_id` BIGINT NULL COMMENT '租户ID',
    `pg_inst_id` VARCHAR ( 64 ) NULL COMMENT '实例ID',
    `pg_gateway_id` BIGINT NULL COMMENT 'Gateway节点ID',
    `alive` boolean NULL COMMENT '进程是否存活',
    `collect_time` DATETIME NULL COMMENT '记录采集时间',
    KEY `idx_time` (`collect_time`)
);

-- 2.7.6 finish