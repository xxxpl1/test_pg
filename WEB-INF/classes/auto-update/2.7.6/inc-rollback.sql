-- 升级失败时，回滚sql时用到，该文件是inc.sql的逆操作文件。
-- 请注意：编写此文件的sql语句，需要具备幂等性，否则有可能导致回滚失败，或者数据不正确。

-- pg start

alter table telepg_spec add column  `spec_desc` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格描述' after spec_name;
update telepg_spec a inner join telepg_inst b  on a.pg_inst_id= b.pg_inst_id set a.spec_desc = b.inst_type_desc;
ALTER TABLE telepg_inst DROP COLUMN `inst_type` ;
ALTER TABLE telepg_inst DROP COLUMN `inst_type_desc` ;


delete from sys_resource where resource_id=100004;
delete from sys_resource where resource_id=100006;
delete from sys_resource where resource_id=100007;
delete from sys_resource where resource_id=100008;
delete from sys_resource where resource_id=100009;
delete from sys_resource where resource_id=100010;
delete from sys_resource where resource_id=100011;

delete from sys_role_permission where role_resource_id=36;
delete from sys_role_permission where role_resource_id=37;
delete from sys_role_permission where role_resource_id=38;
delete from sys_role_permission where role_resource_id=39;
delete from sys_role_permission where role_resource_id=41;
delete from sys_role_permission where role_resource_id=50;
delete from sys_role_permission where role_resource_id=51;

-- pg finish

-- adminservice start
-- 增量脚本涉及太多delete语句，不方便写回滚语句
-- 不回滚了，要求升级前先备份旧数据库。如果升级失败，先恢复数据库再重新升级
-- adminservice finish