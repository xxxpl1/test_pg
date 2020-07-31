-- 2.7.7 start

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
  `backup_compress_size` bigint(64) DEFAULT '0' COMMENT '压缩后备份大小，单位:B',
  `backup_deduplicated_size` bigint(64) DEFAULT '0' COMMENT '表空间的大小，单位:B',
  `process` int(10) DEFAULT '0' COMMENT '备份进度，完成为100',
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
  `isCompress` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`pg_backup_base_info_id`) USING BTREE,
  KEY `idx_tenant_inst` (`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

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





















-- 2.7.7 end