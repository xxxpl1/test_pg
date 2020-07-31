-- 升级失败时，回滚sql时用到，该文件是inc.sql的逆操作文件。
-- 请注意：编写此文件的sql语句，需要具备幂等性，否则有可能导致回滚失败，或者数据不正确。

-- 2.7.5 start
alter table telepg_database rename to pg_database;
alter table telepg_inst_user rename to pg_inst_user;
alter table telepg_gateway rename to pg_gateway;
alter table telepg_inst rename to pg_inst;
alter table telepg_inst_param rename to pg_inst_param;
alter table telepg_spec rename to pg_spec;
alter table telepg_version_info rename to pg_version_info;
alter table telepg_tenant_info rename to pg_tenant_info;
alter table telepg_zookeeper_info rename to pg_zookeeper_info;

alter table pg_gateway change  column pg_host_id `pg_server_id` bigint(20) NULL DEFAULT NULL COMMENT 'PGSQL服务器标识';

-- 2.7.5 end

-- adminbase start
drop table if exists sys_backend_service;
drop table if exists sys_config;
drop table if exists sys_config_group;
drop table if exists sys_dict;
drop table if exists sys_dict_item;
drop table if exists sys_dict_item_rela;
drop table if exists sys_external_app;
drop table if exists sys_external_app_permission;
drop table if exists sys_login_log;
drop table if exists sys_open_api;
drop table if exists sys_operation_log;
drop table if exists sys_org_member;
drop table if exists sys_organization;
drop table if exists sys_resource;
drop table if exists sys_role;
drop table if exists sys_role_permission;
drop table if exists sys_tenant;
drop table if exists sys_tenant_member;
drop table if exists sys_user;
drop table if exists sys_user_data_permission;
drop table if exists sys_user_role;
DROP TABLE IF EXISTS sys_user_current_tenant;
-- adminbase finish