/*
 Navicat Premium Data Transfer

 Source Server         : 192.168.26.128_3306
 Source Server Type    : MySQL
 Source Server Version : 50728
 Source Host           : 192.168.26.128:3306
 Source Schema         : pg_admin_new

 Target Server Type    : MySQL
 Target Server Version : 50728
 File Encoding         : 65001

 Date: 25/02/2020 15:50:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for pg_database
-- ----------------------------
DROP TABLE IF EXISTS `pg_database`;
CREATE TABLE `pg_database`  (
  `pg_database_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '数据库管理标识ID',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户ID',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `db_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据库名称',
  `db_owner` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '数据库所有者',
  `db_encoding` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字符集',
  `db_collate` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字符串排序规则',
  `db_ctype` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '字符分类',
  `create_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`pg_database_id`) USING BTREE,
  INDEX `idx_inst`(`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_inst_user
-- ----------------------------
DROP TABLE IF EXISTS `pg_inst_user`;
CREATE TABLE `pg_inst_user`  (
  `pg_inst_user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PG数据库用户标识',
  `pg_user_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pg_user_pw` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pg_user_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户类型',
  `is_admin` tinyint(1) NOT NULL COMMENT '是否管理员用户',
  `is_show` tinyint(1) NOT NULL COMMENT '对外是否可以展示',
  `pg_user_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pg_user_create_timestamp` datetime(0) NULL DEFAULT NULL,
  `pg_user_update_timestamp` datetime(0) NULL DEFAULT NULL,
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户ID',
  PRIMARY KEY (`pg_inst_user_id`) USING BTREE,
  INDEX `idx_tenant_inst`(`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_gateway
-- ----------------------------
DROP TABLE IF EXISTS `pg_gateway`;
CREATE TABLE `pg_gateway`  (
  `pg_gateway_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务标识',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `pg_server_id` bigint(20) NULL DEFAULT NULL COMMENT 'PGSQL服务器标识',
  `install_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '安装路径',
  `write_port` int(11) NOT NULL COMMENT '数据路径',
  `read_port` int(11) NOT NULL COMMENT '数据路径',
  `service_port` int(11) NOT NULL COMMENT '数据路径',
  `version` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '版本信息',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户标识',
  `create_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '更新时间',
  `zk_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'gateway节点的zookeeper路径',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_gateway_id`) USING BTREE,
  INDEX `idx_tenant_inst`(`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_inst
-- ----------------------------
DROP TABLE IF EXISTS `pg_inst`;
CREATE TABLE `pg_inst`  (
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品实例标识',
  `sku_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单品标识，基础版、高可用版',
  `inst_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例名称',
  `inst_storage` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例存储规格',
  `inst_ipv4` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例ipv4地址',
  `inst_ipv6` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例ipv6地址',
  `inst_port` int(11) NULL DEFAULT NULL COMMENT '实例端口',
  `network_info` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '网络信息',
  `subnet_info` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子网信息',
  `security_info` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安全信息',
  `inst_version` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例版本',
  `inst_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '实例用户',
  `eff_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '生效时间',
  `expire_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '失效时间',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '0-无效 1- 有效 2-删除',
  `status_cd` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户标识',
  `user_id` bigint(20) NOT NULL COMMENT '用户标识',
  `virtual_router_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '虚拟路由器ID',
  `zk_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'pg实例的zookeeper路径',
  `create_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_inst_id`) USING BTREE,
  INDEX `idx_tenant_inst`(`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_inst_param
-- ----------------------------
DROP TABLE IF EXISTS `pg_inst_param`;
CREATE TABLE `pg_inst_param`  (
  `pg_inst_param_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '参数ID',
  `param_type` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '参数类别：pgsql 或者 gateway',
  `param_code` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '参数名称',
  `param_value` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '参数值',
  `status_cd` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `param_default_value` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认参数值',
  `effect_with_restart` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否需要重启才能生效：是/否',
  `param_value_range_min` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数值范围下限',
  `param_value_range_max` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '参数值范围上限',
  `create_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '修改时间',
  `param_desc` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '参数描述',
  `version` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应param_type的版本号',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_inst_param_id`) USING BTREE,
  INDEX `idx_type_version`(`param_type`, `version`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of pg_inst_param
-- ----------------------------
INSERT INTO `pg_inst_param` VALUES (1, 'postgres', 'autovacuum_naptime', '1', '1000', '1', 'NO', '1', '3600', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定自动清理在任意给定数据库上运行的最小延迟。单位(秒)', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (2, 'postgres', 'autovacuum_vacuum_scale_factor', '0', '1000', '0', 'NO', '0', '0.800', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定一个表尺寸的分数，在决定是否触发 VACUUM 时将它加到 autovacuum_vacuum_threshold 上', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (3, 'postgres', 'autovacuum_vacuum_threshold', '1', '1000', '1', 'NO', '1', '99999', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定能在一个表上触发 VACUUM 的被插入、被更新或被删除元组的最小数量', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (4, 'postgres', 'autovacuum_max_workers', '1', '1000', '1', 'YES', '1', '20', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定能同时运行的自动清理进程（除了自动清理启动器之外）的最大数量', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (5, 'postgres', 'autovacuum_vacuum_cost_delay', '-1', '1000', '-1', 'NO', '-1', '100', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定用于自动 VACUUM 操作中的代价延迟值', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (6, 'postgres', 'autovacuum_vacuum_cost_limit', '-1', '1000', '-1', 'NO', '-1', '10000', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定用于自动 VACUUM 操作中的代价限制值', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (7, 'postgres', 'default_statistics_target', '1', '1000', '1', 'NO', '1', '10000', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '为没有通过 ALTER TABLE SET STATISTICS 设置列相关目标的表列设置默认统计目标', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (8, 'postgres', 'log_autovacuum_min_duration', '-1', '1000', '-1', 'NO', '-1', '99999', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '如果自动清理运行至少该值所指定的毫秒数，被自动清理执行的每一个动作都会被日志记录', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (9, 'postgres', 'log_temp_files', '-1', '1000', '-1', 'NO', '-1', '1073741824', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '控制记录临时文件名和尺寸', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (10, 'postgres', 'checkpoint_timeout', '30', '1000', '30', 'NO', '30', '3600', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '自动 WAL 检查点之间的最长时间，单位(秒)', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (11, 'postgres', 'max_standby_streaming_delay', '0', '1000', '0', 'NO', '0', '3600000', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '当热后备机处于活动状态时，这个参数决定取消那些与即将应用的 WAL 项冲突的后备机查询之前，后备服务器应该等待多久', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (12, 'postgres', 'track_activity_query_size', '100', '1000', '100', 'YES', '100', '102400', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '声明保留的字节数，以跟踪每个活动会话的当前执行命令，对pg_stat_activity.current_query 段', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (13, 'postgres', 'vacuum_freeze_table_age', '150000000', '1000', '150000000', 'NO', '150000000', '1500000000', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '当表的 pg_class.relfrozenxid 域达到该设置指定的年龄时， VACUUM 会执行一次全表扫描', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (14, 'postgres', 'autovacuum_analyze_scale_factor', '0.10', '1000', '0.10', 'NO', '0.00', '0.80', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定一个表尺寸的分数，在决定是否触发 ANALYZE 时将它加到 autovacuum_analyze_threshold 上', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (15, 'postgres', 'autovacuum_analyze_threshold', '1', '1000', '1', 'NO', '1', '99999', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定能在一个表上触发 ANALYZE 的被插入、被更新或被删除元组的最小数量', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (16, 'postgres', 'autovacuum_freeze_max_age', '200000000', '1000', '200000000', 'YES', '200000000', '1500000000', '2019-11-13 20:12:43', '2019-11-21 11:05:17', '指定在一个 VACUUM 操作被强制执行来防止表中事务 ID 回卷之前，一个表的 pg_class.relfrozenxid 域能保持的最大年龄（事务的）', '11', NULL);
INSERT INTO `pg_inst_param` VALUES (17, 'postgres', 'wal_level', 'replica', '1000', 'replica', 'YES', 'replica', 'logical', '2019-11-13 20:12:43', '2019-11-21 11:05:17', 'replica ， 它写入足够的数据以支持 WAL 归档和复制，包括在备用服务器上运行只读查询; logical 会增加支持逻辑解码所需的信息', '11', NULL);


-- ----------------------------
-- Table structure for pg_server
-- ----------------------------
DROP TABLE IF EXISTS `pg_server`;
CREATE TABLE `pg_server`  (
  `pg_server_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务器标识',
  `server_mgr_ipv4` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器管理ipv4地址',
  `server_mgr_ipv6` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器管理ipv6地址',
  `server_vpc_ipv4` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器私有ipv4地址',
  `server_vpc_ipv6` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器私有ipv6地址',
  `server_ssh_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器SSH用户',
  `server_ssh_pwd` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器SSH密码',
  `server_ssh_port` int(11) NULL DEFAULT NULL COMMENT '服务器SSH端口',
  `server_image_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器镜像标识',
  `server_cpu` int(11) NULL DEFAULT NULL COMMENT '服务器CPU(核)',
  `server_memory` int(11) NULL DEFAULT NULL COMMENT '服务器内存(G)',
  `server_disk_space` int(11) NULL DEFAULT NULL COMMENT '服务器磁盘空间(G)',
  `status_cd` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识,仅用于标识创建的用户ID',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户标识',
  `create_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_server_id`) USING BTREE,
  INDEX `idx_tenant`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_service
-- ----------------------------
DROP TABLE IF EXISTS `pg_service`;
CREATE TABLE `pg_service`  (
  `pg_service_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务标识',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `pg_server_id` bigint(20) NULL DEFAULT NULL COMMENT 'PGSQL服务器标识',
  `install_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '安装路径',
  `data_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据路径',
  `script_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '脚本路径',
  `backup_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备份路径',
  `service_port` int(11) NOT NULL COMMENT '服务端口',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户标识',
  `zk_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'pg节点的zookeeper路径',
  `create_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_service_id`) USING BTREE,
  INDEX `idx_tenant_inst`(`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pg_spec
-- ----------------------------
DROP TABLE IF EXISTS `pg_spec`;
CREATE TABLE `pg_spec`  (
  `pg_spec_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL规格标识',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `spec_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名称',
  `spec_desc` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格描述',
  `spec_cpu` int(11) NULL DEFAULT NULL COMMENT '规格-CPU(核)',
  `spec_memory` int(11) NULL DEFAULT NULL COMMENT '规格-内存(G)',
  `spec_server_num` int(11) NULL DEFAULT NULL COMMENT '规格-服务器数量',
  `hard_disk_size` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '硬盘空间大小',
  `status_cd` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `create_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` timestamp(0) NULL DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_spec_id`) USING BTREE,
  INDEX `idx_inst`(`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for oper_order
-- ----------------------------
DROP TABLE IF EXISTS `oper_order`;
CREATE TABLE `oper_order` (
  `oper_order_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `biz_id` char(4) NOT NULL COMMENT '操作类型，01-组件开通,11-暂停服务 12-恢复服务 13-注销组件 14-更改产品实例属性 15-预扩容 16-扩容恢复',
  `tenant_id` bigint(20) NOT NULL COMMENT '租户ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `prod_id` varchar(50) NOT NULL COMMENT '产品ID',
  `prod_inst_id` varchar(50) NOT NULL COMMENT '产品实例ID',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '施工状态 0-工单已接收 1-施工中 2-施工失败重试  3-施工已完成',
  `oper_result` tinyint(4) DEFAULT NULL COMMENT '施工结果（不包含回单结果） 0-成功  1-失败',
  `oper_result_desc` longtext COMMENT '施工结果描述',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `retry_num` int(11) NOT NULL DEFAULT '0' COMMENT '重试施工次数',
  `receive_content` longtext NOT NULL COMMENT '接收到的施工协议内容',
  `reply_content` longtext COMMENT '施工回单内容',
  `reply_result` tinyint(4) NOT NULL DEFAULT '0' COMMENT '回单状态 0-未回单 1-回单成功 2-回单失败',
  PRIMARY KEY (`oper_order_id`),
  KEY `idx_state` (`state`) USING BTREE,
  KEY `idx_tenantid` (`tenant_id`),
  KEY `idx_prodinstid` (`prod_inst_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1749 DEFAULT CHARSET=utf8 COMMENT='PaaS平台施工单';

-- ----------------------------
-- Table structure for oper_order_reply_fail
-- ----------------------------
DROP TABLE IF EXISTS `oper_order_reply_fail`;
CREATE TABLE `oper_order_reply_fail` (
  `fail_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `oper_order_id` bigint(20) NOT NULL,
  `reply_content` longtext NOT NULL COMMENT '需要重发的内容json字符串',
  `fail_desc` longtext COMMENT '回单失败原因',
  `reply_num` int(11) NOT NULL COMMENT '已经回单次数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`fail_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COMMENT='回单失败，需要重新回单的内容';

DROP TABLE IF EXISTS `pg_version_info`;
CREATE TABLE `pg_version_info` (
  `version_id` int(10) NOT NULL AUTO_INCREMENT,
  `current_version` varchar(50) NOT NULL COMMENT '当前版本号',
  `last_version` varchar(50) DEFAULT NULL COMMENT '从哪个版本升级过来',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用来记录组件版本，以便升级时确定当前版本';
INSERT INTO `pg_version_info` (`current_version`, `last_version`, `create_time`) VALUES ('2.7.5_RC1', NULL, now());

DROP TABLE IF EXISTS `pg_tenant_info`;
CREATE TABLE `pg_tenant_info` (
  `tenant_id` bigint(20) NOT NULL COMMENT '租户编号',
  `zookeeper_id` bigint(20) NOT NULL COMMENT 'Zookeeper的编号',
  `secondary_namespace` varchar(255) NOT NULL DEFAULT '二级namespace',
  PRIMARY KEY (`tenant_id`),
  KEY `idx_zookeeper`(`zookeeper_id`)  USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pg_zookeeper_info`;
CREATE TABLE `pg_zookeeper_info` (
  `zookeeper_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL DEFAULT 'Zookeeper服务器地址',
  `primary_namespace` varchar(255) NOT NULL DEFAULT '一级namespace',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `enable_acl` bit(1) NOT NULL COMMENT '是否启用acl',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '描述',
  `create_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人名称',
  `update_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`zookeeper_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;


