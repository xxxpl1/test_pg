-- 2.7.5 start
-- 修改pg_server 表,改为 pg_host
DROP TABLE IF EXISTS `telepg_host`;
CREATE TABLE `telepg_host`  (
  `pg_host_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务器标识',
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器名字',
  `mgr_ipv4` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器管理ipv4地址',
  `mgr_ipv6` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器管理ipv6地址',
  `vpc_ipv4` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器私有ipv4地址',
  `vpc_ipv6` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器私有ipv6地址',
  `ssh_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器SSH用户',
  `ssh_pwd` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器SSH密码',
  `ssh_port` int(11) NULL DEFAULT NULL COMMENT '服务器SSH端口',
  `image_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '服务器镜像标识',
  `cpu` int(11) NULL DEFAULT NULL COMMENT '服务器CPU(核)',
  `memory` int(11) NULL DEFAULT NULL COMMENT '服务器内存(G)',
  `disk_space` int(11) NULL DEFAULT NULL COMMENT '服务器磁盘空间(G)',
  `status_cd` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '状态',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识,仅用于标识创建的用户ID',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户标识',
  `create_timestamp` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `type` TINYINT DEFAULT 0 COMMENT '类型,0是自动新建,1是手动建的',
  PRIMARY KEY (`pg_host_id`) USING BTREE,
  INDEX `idx_tenant`(`tenant_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

INSERT INTO `telepg_host`(`pg_host_id`, `mgr_ipv4`, `mgr_ipv6`, `vpc_ipv4`, `vpc_ipv6`, `ssh_user`, `ssh_pwd`, `ssh_port`, `image_id`, `cpu`, `memory`, `disk_space`, `status_cd`, `user_id`, `tenant_id`, `create_timestamp`, `update_timestamp`, `remark`, `type`) select `pg_server_id`, `server_mgr_ipv4`, `server_mgr_ipv6`, `server_vpc_ipv4`, `server_vpc_ipv6`, `server_ssh_user`, `server_ssh_pwd`, `server_ssh_port`, `server_image_id`, `server_cpu`, `server_memory`, `server_disk_space`, `status_cd`, `user_id`, `tenant_id`, `create_timestamp`, `update_timestamp`, `remark` , 0 from pg_server;

drop table pg_server;

-- 修改pg_service表,改为 pg_node
DROP TABLE IF EXISTS `telepg_node`;
CREATE TABLE `telepg_node`  (
  `pg_node_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'PGSQL服务标识',
  `pg_inst_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'PGSQL实例标识',
  `pg_host_id` bigint(20) NULL DEFAULT NULL COMMENT 'PGSQL服务器标识',
  `install_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '安装路径',
  `data_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据路径',
  `script_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '脚本路径',
  `backup_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备份路径',
  `service_port` int(11) NOT NULL COMMENT '服务端口',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户标识',
  `tenant_id` bigint(20) NULL DEFAULT NULL COMMENT '租户标识',
  `zk_path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'pg节点的zookeeper路径',
  `create_timestamp` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_timestamp` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`pg_node_id`) USING BTREE,
  INDEX `idx_tenant_inst`(`tenant_id`,`pg_inst_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;


INSERT INTO `telepg_node`(`pg_node_id`, `pg_inst_id`, `pg_host_id`, `install_path`, `data_path`, `script_path`, `backup_path`, `service_port`, `user_id`, `tenant_id`, `zk_path`, `create_timestamp`, `update_timestamp`, `remark`) select `pg_service_id`, `pg_inst_id`, `pg_server_id`, `install_path`, `data_path`, `script_path`, `backup_path`, `service_port`, `user_id`, `tenant_id`, `zk_path`, `create_timestamp`, `update_timestamp`, `remark` from pg_service;

drop table pg_service;

-- 修改pg_gateway表 ，将pg_server_id列改为pg_host_id
alter table pg_gateway change  column pg_server_id `pg_host_id` bigint(20) NULL DEFAULT NULL COMMENT 'PGSQL服务器标识';
alter table pg_gateway change  column create_timestamp `create_timestamp` datetime NULL DEFAULT NULL COMMENT '创建时间';
alter table pg_gateway change  column update_timestamp `update_timestamp` datetime NULL DEFAULT NULL COMMENT '更新时间';

-- 修改pg_inst表， 增加一列vip
alter table pg_inst add column `vip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '实例的VIP，方便展示和使用' after zk_path;
update pg_inst set vip = inst_ipv4 ;

-- 改表名
alter table pg_database rename to telepg_database;
alter table pg_inst_user rename to telepg_inst_user;
alter table pg_gateway rename to telepg_gateway;
alter table pg_inst rename to telepg_inst;
alter table pg_inst_param rename to telepg_inst_param;
alter table pg_spec rename to telepg_spec;
alter table pg_tenant_info rename to telepg_tenant_info;
alter table pg_zookeeper_info rename to telepg_zookeeper_info;
-- 2.7.5 finish

-- adminbase start
-- end at line 1126
-- v1.0.0

-- 数据字典全量
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

/*==============================================================*/
/* Table: sys_backend_service                                   */
/*==============================================================*/
create table sys_backend_service
(
   service_id           bigint not null auto_increment comment '匹配规则标识',
   resource_code        varchar(100) comment '资源编码',
   match_path           varchar(64) comment '匹配地址',
   method               varchar(255) not null comment '提交方式 *-代表所有， 参考： SYS_REQUEST_METHOD',
   permission           tinyint default 1 comment '权限字符串',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   description          varchar(255) comment '描述',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (service_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_backend_service comment '后端服务匹配（sys_backend_service）';

/*==============================================================*/
/* Table: sys_config                                            */
/*==============================================================*/
create table sys_config
(
   config_id            bigint not null auto_increment comment '配置项标识',
   group_code           varchar(50) not null comment '分组编码',
   config_code          varchar(50) not null comment '配置编码',
   config_value         text comment '配置值',
   config_value_name    varchar(100) not null comment '配置值名称',
   config_desc          varchar(255) comment '配置描述',
   input_type           varchar(20) comment '输入类型，参考 SYS_INPUT_TYPE, number 整数、singleline  单行输入、multiline  多行输入、pulldown下拉、checkbox 多选按钮、radiobox  单选按钮 ',
   input_scope          varchar(255) comment '输入值范围',
   list_order           integer not null default 0 comment '排序',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (config_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table sys_config comment '配置表（sys_config）';

/*==============================================================*/
/* Table: sys_config_group                                      */
/*==============================================================*/
create table sys_config_group
(
   group_id             bigint not null auto_increment comment '分组标识',
   group_code           varchar(50) not null comment '分组编码',
   group_name           varchar(100) not null comment '分组名称',
   group_desc           varchar(200) comment '分组描述',
   can_modify           tinyint not null default 1 comment '是否允许在界面上修改配置项的值',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   primary key (group_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table sys_config_group comment '配置分组（sys_config_group）';

/*==============================================================*/
/* Table: sys_dict                                              */
/*==============================================================*/
create table sys_dict
(
   dict_id              bigint not null auto_increment comment '字典标识',
   parent_id            bigint default 0 comment '父字典标识',
   dict_code            varchar(50) not null comment '字典编码',
   dict_name            varchar(100) not null comment '字典名称',
   dict_tip             varchar(255) comment '字典提示，用于界面显示',
   dict_desc            varchar(200) comment '字典描述',
   can_modify           tinyint not null default 1 comment '是否允许在界面上修改配置项的值',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   primary key (dict_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_dict comment '字典表（sys_dict）';

/*==============================================================*/
/* Table: sys_dict_item                                         */
/*==============================================================*/
create table sys_dict_item
(
   item_id              bigint not null auto_increment comment '配置项标识',
   dict_code            varchar(50) not null comment '配置编码',
   item_code            varchar(30) not null comment '配置项编码',
   item_value           varchar(255) comment '配置项值',
   item_desc            varchar(255) comment '配置项描述',
   is_default           tinyint not null default 0 comment '是否默认值，0-否 1-是',
   list_order           integer not null default 0 comment '排序',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (item_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table sys_dict_item comment '字典项表（sys_dict_item）';

/*==============================================================*/
/* Table: sys_dict_item_rela                                    */
/*==============================================================*/
create table sys_dict_item_rela
(
   rela_id              bigint not null auto_increment comment '关联标识',
   primary_dict_code    varchar(50) not null comment '主字典编码',
   primary_item_code    varchar(50) not null comment '主字典项编码',
   sub_dict_code        varchar(50) comment '子字典编码',
   sub_item_code        varchar(50) not null default '0' comment '子字典项编码',
   list_order           integer not null default 0 comment '排序',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (rela_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;

alter table sys_dict_item_rela comment '字典项关联关系（sys_dict_item_rela）';

/*==============================================================*/
/* Table: sys_external_app                                      */
/*==============================================================*/
create table sys_external_app
(
   app_id               bigint not null auto_increment comment '应用标识',
   app_name             varchar(100) comment '应用名称',
   app_key              varchar(100) comment 'app key',
   app_secret           varchar(100) not null comment 'app secret',
   tenant_id            bigint not null comment '租户标识',
   app_desc             varchar(255) comment '应用描述',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (app_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_external_app comment '外部应用（sys_external_app）';

/*==============================================================*/
/* Table: sys_external_app_permission                           */
/*==============================================================*/
create table sys_external_app_permission
(
   permission_id        bigint not null auto_increment comment '权限标识',
   app_id               bigint comment '应用标识',
   api_id               bigint comment 'api标识',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   primary key (permission_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_external_app_permission comment '应用api权限（sys_external_app_permission）';

/*==============================================================*/
/* Table: sys_login_log                                         */
/*==============================================================*/
create table sys_login_log
(
   login_id             bigint not null auto_increment comment '日志标识',
   user_id              bigint not null comment '会员标识',
   tenant_code          varchar(30) not null comment '租户编码',
   user_name            varchar(50) comment '会员名',
   login_time           datetime not null comment '登录时间',
   session_id           varchar(100) not null comment 'session标识',
   login_ip             varchar(30) comment '登录IP',
   login_url            varchar(255) comment '登录URL，请求来源',
   login_type           varchar(10) comment 'web - pc浏览器  wx-微信小程序， 参考SYS_LOGIN_TYPE',
   device               varchar(100) comment '登录设备的编码',
   is_success           tinyint comment '0：否 1：是',
   fail_type            varchar(20) comment '10：密码错误 15：账户锁定 99：其他，参考：SYS_LOGIN_FAIL_TYPE',
   fail_detail          varchar(255) comment '登录失败详情',
   logout_time          datetime comment '退出时间',
   primary key (login_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_login_log comment '登录日志，存放到数据库表数据量过大，建议采集到日志中心';

/*==============================================================*/
/* Table: sys_open_api                                          */
/*==============================================================*/
create table sys_open_api
(
   api_id               bigint not null auto_increment comment 'api标识',
   match_path           varchar(200) comment 'api匹配地址',
   method               varchar(50) not null comment '提交方式 *-代表所有，参考： SYS_REQUEST_METHOD',
   api_name             varchar(100) default '1' comment 'api名称',
   api_desc             varchar(255) comment 'api描述',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   primary key (api_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_open_api comment 'open api定义（sys_open_api）';

/*==============================================================*/
/* Table: sys_operation_log                                     */
/*==============================================================*/
create table sys_operation_log
(
   log_id               bigint not null auto_increment comment '日志标识',
   user_id              bigint not null comment '会员标识',
   user_name            varchar(50) comment '会员名',
   tenant_code          varchar(30) not null comment '租户编码',
   login_ip             varchar(30) comment '操作IP',
   oper_type            varchar(50) not null comment '操作类型',
   oper_content         varchar(2000) not null comment '操作内容，json格式',
   created_time         datetime not null comment '创建时间',
   primary key (log_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_operation_log comment '操作日志';

/*==============================================================*/
/* Table: sys_org_member                                        */
/*==============================================================*/
create table sys_org_member
(
   member_id            bigint not null auto_increment comment '成员标识',
   user_id              bigint not null comment '会员标识',
   tenant_id            bigint not null comment '租户标识',
   org_id               bigint not null default 0 comment '机构标识',
   created_time         datetime not null comment '创建时间',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除',
   primary key (member_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_org_member comment '组织成员（sys_org_member）';

/*==============================================================*/
/* Table: sys_organization                                      */
/*==============================================================*/
create table sys_organization
(
   org_id               bigint not null auto_increment comment '机构标识',
   tenant_id            bigint comment '租户标识',
   parent_id            bigint comment '上级机构标识',
   parent_ids           varchar(255) comment '上级机构列表 如1,2,3表示其祖先是3、2、1；其中根节点父编号为1',
   org_name             varchar(255) not null comment '机构名称',
   description          varchar(255) comment '机构描述',
   created_time         datetime not null comment '创建时间',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   primary key (org_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_organization comment '租户机构';

/*==============================================================*/
/* Table: sys_resource                                          */
/*==============================================================*/
create table sys_resource
(
   resource_id          bigint not null auto_increment comment '资源ID',
   resource_code        varchar(100) comment '资源编码',
   icon                 varchar(64) comment '图标',
   resource_name        varchar(255) not null comment '资源名称',
   resource_type        tinyint default 1 comment '资源类型 1：菜单 2：按钮 3：接口（非显性界面调用），参考SYS_RESOURCE_TYPE',
   parent_code          varchar(100) comment '父资源编码',
   parent_id            bigint comment '父资源标识 如果类型按钮，值为所属菜单标识',
   parent_ids           varchar(255) comment '父资源列表 如1,2,3表示其祖先是3、2、1；其中根节点父编号为1',
   url                  varchar(255) comment 'URL',
   target               varchar(64) default '_self' comment '链接打开方式，参考： SYS_HREF_TARGET',
   hidden               tinyint default 1 comment '是否隐藏  0-隐藏 1-显示',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   list_order           integer not null default 0 comment '排序',
   description          varchar(255) comment '资源描述',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   primary key (resource_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_resource comment '资源（sys_resource）';

/*==============================================================*/
/* Table: sys_role                                              */
/*==============================================================*/
create table sys_role
(
   role_id              bigint not null auto_increment comment '角色标识',
   tenant_id            bigint not null comment '租户标识',
   role_name            varchar(100) not null comment '角色名称',
   role_code            varchar(100) not null comment '角色编码',
   description          varchar(255) comment '角色描述',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效',
   primary key (role_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_role comment '角色';

/*==============================================================*/
/* Table: sys_role_permission                                   */
/*==============================================================*/
create table sys_role_permission
(
   role_resource_id     bigint not null auto_increment comment '角色资源关联标识',
   role_id              bigint comment '角色标识',
   resource_id          bigint comment '资源ID',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   primary key (role_resource_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_role_permission comment '角色权限';

/*==============================================================*/
/* Table: sys_tenant                                            */
/*==============================================================*/
create table sys_tenant
(
   tenant_id            bigint not null auto_increment comment '租户标识',
   tenant_code          varchar(100) not null comment '租户编码',
   tenant_name          varchar(200) not null comment '租户名称',
   description          varchar(255) comment '租户描述',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除',
   primary key (tenant_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_tenant comment '租户';

/*==============================================================*/
/* Table: sys_tenant_member                                     */
/*==============================================================*/
create table sys_tenant_member
(
   member_id            bigint not null auto_increment comment '成员标识',
   user_id              bigint not null comment '会员标识',
   tenant_id            bigint not null comment '租户标识',
   remark_name          varchar(50) comment '备注名',
   is_owner             tinyint not null comment '是否拥有者 0-否 1-是',
   created_time         datetime not null comment '创建时间',
   modified_time        datetime comment '修改时间',
   status               tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除',
   primary key (member_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_tenant_member comment '租户成员';

/*==============================================================*/
/* Table: sys_user                                              */
/*==============================================================*/
create table sys_user
(
   user_id              bigint not null auto_increment comment '会员标识',
   account_type         tinyint not null default 0 comment '账号类型 0-普通用户 1-管理用户，参考： SYS_ACCOUNT_TYPE',
   user_name            varchar(50) not null comment '会员名',
   avatar               varchar(255) comment '头像，头像对应的地址',
   real_name            varchar(50) comment '会员真实姓名',
   user_pwd             varchar(32) not null comment '会员密码',
   pwd_exp_date         datetime comment '密码失效时间',
   salt                 varchar(32) not null comment '会员密码盐',
   mobilephone          varchar(30) comment '手机号码',
   email                varchar(50) comment 'email',
   login_fail_no        int default 0 comment '登录失败次数',
   lock_date            datetime comment '锁定时间',
   email_verify         tinyint not null default 0 comment '0-未验证 1-已验证',
   mobilephone_verify   tinyint not null default 0 comment '0-未验证 1-已验证',
   user_status          tinyint not null default 1 comment '会员状态1-正常、2-锁定、3-密码过期、4-账号过期、5-注销，参考 SYS_USER_STATUS',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   modified_by          bigint comment '修改人',
   modified_time        datetime comment '修改时间',
   last_login_time      datetime comment '最近一次登录时间',
   login_expire_time    datetime comment '登录失效时间',
   primary key (user_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_user comment '会员， 会员名称、手机号码、email针对不同的账号类型全局唯一';

/*==============================================================*/
/* Table: sys_user_data_permission                              */
/*==============================================================*/
create table sys_user_data_permission
(
   rela_id              bigint not null auto_increment comment '关联标识',
   user_id              bigint not null comment '会员标识',
   tenant_code          varchar(30) not null comment '租户编码',
   obj_type             varchar(10) not null comment '对象类型，参考 SYS_OBJ_TYPE',
   obj_id               varchar(50) not null comment '对象标识',
   created_by           bigint not null comment '创建人',
   created_time         datetime not null comment '创建时间',
   primary key (rela_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_user_data_permission comment '成员数据权限';

/*==============================================================*/
/* Table: sys_user_role                                         */
/*==============================================================*/
create table sys_user_role
(
   user_role_id         bigint not null auto_increment comment '用户角色关联标识',
   user_id              bigint comment '会员标识',
   role_id              bigint comment '角色标识',
   tenant_id            bigint comment '租户标识',
   created_by           bigint comment '创建人',
   created_time         datetime not null comment '创建时间',
   primary key (user_role_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

alter table sys_user_role comment '会员角色';

-- 系统管理
-- 日期：2020.01.20
-- 作者：liaoqb

-- 支持中文编码
set names UTF8;

-- 0代表预先设置的用户
-- 状态值，0代表冻结，1代表正常
-- 插入系统默认管理员账户
insert into `sys_tenant`(`tenant_code`, `tenant_name`, `description`, `created_by`, `created_time`, `modified_time`, `status`)
values('sysmgr', 'sysmgr', 'sysmgr', 0, now(), null, 1);

-- 账号类型 0-普通用户 1-管理用户，创建的root用户为管理用户
-- 会员状态1-正常、2-锁定、3-密码过期、4-账号过期、5-注销
-- account/password: root/root
insert into `sys_user`(`account_type`, `user_name`, `avatar`, `real_name`, `user_pwd`, `pwd_exp_date`, `salt`,
`mobilephone`, `email`, `login_fail_no`, `lock_date`, `email_verify`, `mobilephone_verify`, `user_status`, `created_by`,
`created_time`, `modified_by`, `modified_time`)
values(1, 'root', null, '超级管理员', '61b4ce300a145a99c1636116eecbc337', null, 'wpzrfwg5iem3f9op', null, null, null, null,
0, 0, 1, 0, now(), null, null);

-- 将管理员账号添加到管理员租户之中
-- 是否拥有者 0-否 1-是
-- 状态值，0代表冻结，1代表正常
insert into `sys_tenant_member`(`user_id`, `tenant_id`, `remark_name`, `is_owner`, `created_time`, `modified_time`, `status`)
values(
(select user_id from sys_user where user_name='root'),
(select tenant_id from sys_tenant where tenant_code='sysmgr'),
'root_account', 1, now(), null, 1);

-- 创建默认管理者角色
-- 默认管理者角色具有所有api权限
-- 如果租户id是-1, 则代表角色不从属于任何租户，目前默认是-1
insert into `sys_role`(`tenant_id`, `role_name`, `role_code`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`, `status`)
values(-1, '系统管理', 'sysmgr', '系统管理权限角色', 0, now(), null, null, 1);

-- 创建默认会员角色
-- 将系统管理租户添加到会员角色里面
insert into `sys_user_role`(`user_id`, `role_id`, `tenant_id`, `created_by`, `created_time`)
values(
(select user_id from sys_user where user_name='root'),
(select role_id from sys_role where role_code='sysmgr'),
(select tenant_id from sys_tenant where tenant_code='sysmgr'),
0, now());

-- 插入后端系统管理默认的api接口
-- 方法中*代表接口所有类型
insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('log_out', '/logout/**', 'DELETE', null, 1, 'log_out', 0, now(), null, null);

-- 适配paas两个请求接口
insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('paas_adaptor', '/iam/users/**', '*', null, 1, 'paas_adaptor', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('update_password', '/updatePassword/**', 'PUT', null, 1, 'update_password', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('update_user_password', '/updateUserPassword/**', 'PUT', null, 1, 'update_user_password', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_tenant', '/sysmgr/sysTenant/**', '*', null, 1, 'sys_tenant', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_user', '/sysmgr/sysUser/**', '*', null, 1, 'sys_user', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_tenant_member', '/sysmgr/sysTenantMember/**', '*', null, 1, 'sys_tenant_member', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_user_role', '/sysmgr/sysUserRole/**', '*', null, 1, 'sys_user_role', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_role', '/sysmgr/sysRole/**', '*', null, 1, 'sys_role', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_role_permission', '/sysmgr/sysRolePermission/**', '*', null, 1, 'sys_role_permission', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_resource', '/sysmgr/sysResource/**', '*', null, 1, 'sys_resource', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_backend_service', '/sysmgr/sysBackendService/**', '*', null, 1, 'sys_backend_service', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_login_log', '/sysmgr/sysLoginLog/**', '*', null, 1, 'sys_login_log', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_operation_log', '/sysmgr/sysOperationLog/**', '*', null, 1, 'sys_operation_log', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_user_data_permission', '/sysmgr/sysUserDataPermission/**', '*', null, 1, 'sys_user_data_permission', 0, now(), null, null);

-- 数据字典后端服务选项
insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_config', '/sysmgr/sysConfig/**', '*', null, 1, 'sys_config', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_config_group', '/sysmgr/sysConfigGroup/**', '*', null, 1, 'sys_config_group', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_dict', '/sysmgr/sysDict/**', '*', null, 1, 'sys_dict', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_dict_item', '/sysmgr/sysDictItem/**', '*', null, 1, 'sys_dict_item', 0, now(), null, null);

insert into `sys_backend_service`(`resource_code`, `match_path`, `method`, `permission`, `status`, `description`,
`created_by`, `created_time`, `modified_by`, `modified_time`) values
('sys_dict_item_rela', '/sysmgr/sysDictItemRela/**', '*', null, 1, 'sys_dict_item_rela', 0, now(), null, null);

-- 插入资源表字段
-- 根菜单
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('admin-service-base', null, '系统管理', 1, null, null, null,
'http://192.168.89.87:10086/dcos', '_self', 1, 1, 1, 'root menu', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('admin-service-base-api', null, '系统管理API', 1, null, null, null,
'http://192.168.89.87:10086/dcos', '_self', 0, 1, 1, 'api root', 0, now(), null, null);

-- 目前接口外挂在系统管理菜单下面
-- log_out
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('log_out', null, 'log_out', 3, 'admin-service-base-api', null, null,
null, null, 1, 1, 1, 'log_out', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('paas_adaptor', null, 'paas_adaptor', 3, 'admin-service-base-api', null, null,
null, null, 1, 1, 1, 'paas_adaptor', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('update_password', null, 'update_password', 3, 'admin-service-base-api', null,
null, null, null, 1, 1, 1, 'update_password', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('update_user_password', null, 'update_user_password', 3, 'admin-service-base-api',
null, null, null, null, 1, 1, 1, 'update_user_password', 0, now(), null, null);

-- sys_tenant
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_tenant', null, 'sys_tenant', 3, 'admin-service-base-api', null, null, null,
null, 1, 1, 2, 'sys_tenant', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_user', null, 'sys_user', 3, 'admin-service-base-api', null, null, null,
null, 1, 1, 3, 'sys_user', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_tenant_member', null, 'sys_tenant_member', 3, 'admin-service-base-api',
null, null, null, null, 1, 1, 4, 'sys_tenant_member', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_user_role', null, 'sys_user_role', 3, 'admin-service-base-api', null, null,
null, null, 1, 1, 5, 'sys_user_role', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_role', null, 'sys_role', 3, 'admin-service-base-api', null, null, null,
null, 1, 1, 6, 'sys_role', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_role_permission', null, 'sys_role_permission', 3, 'admin-service-base-api',
null, null, null, null, 1, 1, 7, 'sys_role_permission', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_resource', null, 'sys_resource', 3, 'admin-service-base-api', null, null,
null, null, 1, 1, 8, 'sys_resource', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_backend_service', null, 'sys_backend_service', 3, 'admin-service-base-api',
null, null, null, null, 1, 1, 8, 'sys_backend_service', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_login_log', null, 'sys_login_log', 3, 'admin-service-base-api', null, null,
null, null, 1, 1, 8, 'sys_login_log', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_operation_log', null, 'sys_operation_log', 3, 'admin-service-base-api',
null, null, null, null, 1, 1, 8, 'sys_operation_log', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_user_data_permission', null, 'sys_user_data_permission', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_user_data_permission', 0, now(), null, null);

-- 数据字典资源配置
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_config', null, 'sys_config', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_config', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_config_group', null, 'sys_config_group', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_config_group', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_dict', null, 'sys_dict', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_dict', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_dict_item', null, 'sys_dict_item', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_dict_item', 0, now(), null, null);

insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('sys_dict_item_rela', null, 'sys_dict_item_rela', 3,
'admin-service-base-api', null, null, null, null, 1, 1, 8, 'sys_dict_item_rela', 0, now(), null, null);

-- 将dcos菜单挂到系统管理目录下面
-- 租户管理
--     租户列表
--     租户成员
-- 用户管理
--     用户列表
--     角色列表
-- 资源管理
--     资源列表
--     后端服务
-- 能力开放
--     应用列表
--     API列表

-- 租户管理
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('tenant_manage', null, '租户管理', 1, 'admin-service-base', null, null, null,
'_self', 1, 1, 1, 'tenant_manage', 0, now(), null, null);

-- 租户信息
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('tenant_message', null, '租户列表', 1, 'tenant_manage', null, null,
'account-tenant-list', '_self', 0, 1, 1, 'tenant_message', 0, now(), null, null);

-- 租户用户
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('tenant_user', null, '租户成员', 1, 'tenant_manage', null, null, 'account-user-list',
'_self', 0, 1, 2, 'tenant_user', 0, now(), null, null);

-- 用户管理
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('user_manage', null, '用户管理', 1, 'admin-service-base', null, null, null,
'_self', 1, 1, 2, 'user_manage', 0, now(), null, null);

-- 用户信息
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('user_message', null, '用户列表', 1, 'user_manage', null, null, 'admin-control-list',
'_self', 0, 1, 1, 'user_message', 0, now(), null, null);

-- 角色信息
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('role_message', null, '角色列表', 1, 'user_manage', null, null, 'role-control-list',
'_self', 0, 1, 2, 'role_message', 0, now(), null, null);

-- 资源管理
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('resource_manage', null, '资源管理', 1, 'admin-service-base', null, null, null,
'_self', 1, 1, 3, 'resource_manage', 0, now(), null, null);

-- 资源信息
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('resource_message', null, '资源列表', 1, 'resource_manage', null, null,
'version-resource-list', '_self', 0, 1, 1, 'resource_message', 0, now(), null, null);

-- 后端服务
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('backend_service', null, '后端服务', 1, 'resource_manage', null, null,
'backend-service-list', '_self', 0, 1, 2, 'backend_service', 0, now(), null, null);

-- 能力开放
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('api_gateway', null, '能力开放', 1, 'admin-service-base', null, null, null,
'_self', 1, 1, 4, 'api_gateway', 0, now(), null, null);

-- 应用信息
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('app_message', null, '应用列表', 1, 'api_gateway', null, null, null,
'_self', 0, 1, 1, 'app_message', 0, now(), null, null);

-- 服务注册
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('service_register', null, 'API列表', 1, 'api_gateway', null, null, null,
'_self', 0, 1, 2, 'service_register', 0, now(), null, null);

-- 将parent_id关联集群，确保查询时候方便进行处理
set @api_parent_id=(select resource_id from sys_resource where resource_code='admin-service-base-api');
update sys_resource set parent_id=@api_parent_id, parent_ids=@api_parent_id where parent_code='admin-service-base-api';

set @parent_id=(select resource_id from sys_resource where resource_code='admin-service-base');
update sys_resource set parent_id=@parent_id, parent_ids=@parent_id where parent_code='admin-service-base';

-- 二级菜单目录插入
set @tenant_parent_id=(select resource_id from sys_resource where resource_code='tenant_manage');
update sys_resource set parent_id=@tenant_parent_id, parent_ids=concat_ws(',', @tenant_parent_id, @parent_id) where parent_code='tenant_manage';

set @user_parent_id=(select resource_id from sys_resource where resource_code='user_manage');
update sys_resource set parent_id=@user_parent_id, parent_ids=concat_ws(',', @user_parent_id, @parent_id) where parent_code='user_manage';

set @resource_parent_id=(select resource_id from sys_resource where resource_code='resource_manage');
update sys_resource set parent_id=@resource_parent_id, parent_ids=concat_ws(',', @resource_parent_id, @parent_id) where parent_code='resource_manage';

set @api_parent_id=(select resource_id from sys_resource where resource_code='api_gateway');
update sys_resource set parent_id=@api_parent_id, parent_ids=concat_ws(',', @api_parent_id, @parent_id) where parent_code='api_gateway';

-- 创建角色权限，将根菜单权限添加到默认角色上面
insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='admin-service-base'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='admin-service-base-api'), 0, now());

-- v1.0.1
-- liaoqiaobo
-- 2020.02.26

-- 创建用户默认角色
insert into `sys_role`(`tenant_id`, `role_name`, `role_code`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`, `status`)
values(-1, 'default_role', 'default_role', 'default_role', 0, now(), null, null, 1);

-- 这里使用的是希望用户默认具有的api权限
insert into `sys_resource`(`resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`,
`parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`,
`modified_by`, `modified_time`) values('default-api', null, '系统默认API', 1, null, null, null,
null, '_self', 1, 1, 1, 'default api', 0, now(), null, null);

set @api_parent_id=(select resource_id from sys_resource where resource_code='default-api');
update sys_resource set parent_id=@api_parent_id, parent_ids=@api_parent_id, parent_code='default-api'
where resource_code in ('log_out', 'paas_adaptor', 'update_password');

-- 创建用户角色
insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='default-api'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='default_role'),
(select resource_id from sys_resource where resource_code='default-api'), 0, now());

-- v1.0.3
-- liaoqiaobo
-- 2020.03.09

-- ----------------------------
-- Table structure for sys_user_current_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_current_tenant`;
CREATE TABLE `sys_user_current_tenant` (
  `current_id` bigint NOT NULL auto_increment COMMENT '目前用户Id',
  `user_id` bigint NOT NULL COMMENT '会员标识',
  `tenant_id` bigint DEFAULT NULL COMMENT '租户标识',
  `modified_by` bigint comment '修改人',
  `modified_time` datetime comment '修改时间',
  PRIMARY KEY (`current_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='会员当前租户';
-- v1.0.4
-- liaoqiaobo
-- 2020.03.12

-- 修改表中的时间字段为数据库默认时间
alter table `sys_backend_service` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_backend_service` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_config` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_config` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_dict` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_dict` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_dict_item` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_dict_item` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_dict_item_rela` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_dict_item_rela` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_external_app` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_external_app` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_external_app_permission` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_external_app_permission` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_open_api` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_open_api` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_operation_log` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_operation_log` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_org_member` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_org_member` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_organization` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_organization` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_resource` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_resource` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_role` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_role` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_role_permission` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_role_permission` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_tenant` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_tenant` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_tenant_member` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_tenant_member` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_user` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_user` modify column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_user_current_tenant` modify column `modified_time` datetime default CURRENT_TIMESTAMP;
alter table `sys_user_current_tenant` add column `created_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_user_data_permission` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_user_data_permission` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

alter table `sys_user_role` modify column `created_time` datetime default CURRENT_TIMESTAMP not null;
alter table `sys_user_role` add column `modified_time` datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP;

-- v1.0.7
-- liaoqiaobo
-- 2020.03.12

-- 添加表中的状态值，支持逻辑删除
alter table `sys_user` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_user` set status=1;

alter table `sys_login_log` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_login_log` set status=1;

alter table `sys_operation_log` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_operation_log` set status=1;

alter table `sys_role_permission` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_role_permission` set status=1;

alter table `sys_user_current_tenant` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_user_current_tenant` set status=1;

alter table `sys_user_data_permission` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_user_data_permission` set status=1;

alter table `sys_user_role` add column `status` tinyint not null default 1 comment '状态  0-无效 1-有效 2-删除';
update `sys_user_role` set status=1;

-- 姜楠更新了前端tag，数据库要同步更新
update `sys_resource` set url='resource-list' where resource_code='resource_message';

-- liaoqb 200.04.02
-- 所有的菜单都需要添加sql

-- 所有的菜单都需要关联到角色
insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='tenant_manage'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='tenant_message'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='tenant_user'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='user_manage'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='user_message'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='role_message'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='resource_manage'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='resource_message'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='backend_service'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='api_gateway'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='app_message'), 0, now());

insert into `sys_role_permission`(`role_id`, `resource_id`, `created_by`, `created_time`) values
(
(select role_id from sys_role where role_code='sysmgr'),
(select resource_id from sys_resource where resource_code='service_register'), 0, now());

-- resource_code 接口类型api修改
update sys_resource set resource_type = 3 where resource_code = 'admin-service-base-api';
update sys_resource set resource_type = 3 where resource_code = 'default-api';
alter table `sys_open_api` add column `secret_check` tinyint(4) NOT NULL DEFAULT '1'
COMMENT '0 - 不需要校检app_secret, 1 - 需要校检app_secret';
alter table `sys_external_app` add column `use_default_user` tinyint(4) NOT NULL DEFAULT '0'
COMMENT '0 - 用户需要传入user_id, 1 - 如果用户不传入user_id，则使用默认的user作为用户传入';
-- adminbase finish

-- pg start
-- 角色 start
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_code`, `description`, `created_by`, `created_time`, `status`) VALUES ('3', '-1', 'PG-超级管理员', 'superadmin', '预置超级管理员', '0', '2020-03-30 00:00:00', '1');
-- 角色 finish

-- 菜单 start
INSERT INTO `sys_resource` (`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`) VALUES (100001, 'PostgreSQL', 'fenbushishujuku', 'PostgreSQL', 1, null, null, null, '', '_blank', 0, 1, 9, null, '1', '2020-03-30 00:00:00');
INSERT INTO `sys_resource` (`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`) VALUES (100002, 'instList', null, '实例列表', 1, 'PostgreSQL', 100001, '100001', 'index', '_self', 1, 1, 0, null, '1', '2020-03-30 00:00:00');
INSERT INTO `sys_resource` (`resource_id`, `resource_code`, `icon`, `resource_name`, `resource_type`, `parent_code`, `parent_id`, `parent_ids`, `url`, `target`, `hidden`, `status`, `list_order`, `description`, `created_by`, `created_time`) VALUES (100003, 'host', null, '主机管理', 1, 'PostgreSQL', 100001, '100001', 'hostManage', '_self', 1, 1, 2, null, '1', '2020-03-30 00:00:00');
-- 菜单 finish

-- 菜单-角色 start
INSERT INTO `sys_role_permission` (`role_id`, `resource_id`, `created_by`, `created_time`) VALUES (3, 100001, '0', '2020-03-30 00:00:00');
INSERT INTO `sys_role_permission` (`role_id`, `resource_id`, `created_by`, `created_time`) VALUES (3, 100002, '0', '2020-03-30 00:00:00');
INSERT INTO `sys_role_permission` (`role_id`, `resource_id`, `created_by`, `created_time`) VALUES (3, 100003, '0', '2020-03-30 00:00:00');
-- 菜单-角色 finish

-- 资源编码-后端服务api sys_backend_service
INSERT INTO `sys_backend_service` (`resource_code`, `match_path`, `method`, `permission`, `status`, `description`, `created_by`, `created_time`) VALUES ('PostgreSQL', '/**', '*', NULL, '1', '', '0', '2020-03-30 00:00:00');

-- root 用户授予sysmgr租户下的superadmin角色
INSERT INTO `sys_user_role` (`user_id`, `role_id`, `tenant_id`, `created_by`, `created_time`, `status`) VALUES (1, 3, 1, 0, '2020-03-30 00:00:00', 1);

-- pg 菜单、权限 finish
-- 2.7.5 finish