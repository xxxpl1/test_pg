(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-715b77b6"],{"05d7":function(t,e,a){},"11e9":function(t,e,a){var r=a("52a7"),n=a("4630"),s=a("6821"),i=a("6a99"),o=a("69a8"),c=a("c69a"),l=Object.getOwnPropertyDescriptor;e.f=a("9e1e")?l:function(t,e){if(t=s(t),e=i(e,!0),c)try{return l(t,e)}catch(a){}if(o(t,e))return n(!r.f.call(t,e),t[e])}},"2b4a":function(t,e,a){"use strict";var r=a("05d7"),n=a.n(r);n.a},"456d":function(t,e,a){var r=a("4bf8"),n=a("0d58");a("5eda")("keys",(function(){return function(t){return n(r(t))}}))},"46a3":function(t,e,a){},"4bb5":function(t,e,a){"use strict";a.d(e,"a",(function(){return s}));var r=a("65d9"),n=a("2f62"),s=(i("computed",n["mapState"]),i("computed",n["mapGetters"]));i("methods",n["mapActions"]),i("methods",n["mapMutations"]);function i(t,e){function a(a,n){return Object(r["createDecorator"])((function(r,s){r[t]||(r[t]={});var i,o=(i={},i[s]=a,i);r[t][s]=void 0!==n?e(n,o)[s]:e(o)[s]}))}function n(t,e){if("string"===typeof e){var r=e,n=t;return a(r,void 0)(n,r)}var s=o(e),i=t;return a(i,s)}return n}function o(t){var e=t&&t.namespace;if("string"===typeof e)return"/"!==e[e.length-1]?e+"/":e}},"4fe6":function(t,e,a){},"5eda":function(t,e,a){var r=a("5ca1"),n=a("8378"),s=a("79e5");t.exports=function(t,e){var a=(n.Object||{})[t]||Object[t],i={};i[t]=e(a),r(r.S+r.F*s((function(){a(1)})),"Object",i)}},"7f7f":function(t,e,a){var r=a("86cc").f,n=Function.prototype,s=/^\s*function ([^ (]*)/,i="name";i in n||a("9e1e")&&r(n,i,{configurable:!0,get:function(){try{return(""+this).match(s)[1]}catch(t){return""}}})},"8e6e":function(t,e,a){var r=a("5ca1"),n=a("990b"),s=a("6821"),i=a("11e9"),o=a("f1ae");r(r.S,"Object",{getOwnPropertyDescriptors:function(t){var e,a,r=s(t),c=i.f,l=n(r),u={},p=0;while(l.length>p)a=c(r,e=l[p++]),void 0!==a&&o(u,e,a);return u}})},9093:function(t,e,a){var r=a("ce10"),n=a("e11e").concat("length","prototype");e.f=Object.getOwnPropertyNames||function(t){return r(t,n)}},"990b":function(t,e,a){var r=a("9093"),n=a("2621"),s=a("cb7c"),i=a("7726").Reflect;t.exports=i&&i.ownKeys||function(t){var e=r.f(s(t)),a=n.f;return a?e.concat(a(t)):e}},a097:function(t,e,a){"use strict";a.r(e);var r=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",[a("div",{staticClass:"header-content"},[a("span",{staticStyle:{"margin-left":"30px"}},[t._v("备份机管理")]),a("el-button",{staticStyle:{"margin-right":"20px","margin-top":"10px",position:"fixed",right:"0"},attrs:{type:"primary",id:"primary-button-style"},on:{click:t.createBackup}},[t._v("创建备份机")])],1),a("div",{staticClass:"instance-list-wrap"},[a("div",{staticClass:"search-style"},[a("el-input",{staticClass:"InputStyle",attrs:{placeholder:"请输入备份机名查询"},model:{value:t.name,callback:function(e){t.name=e},expression:"name"}},[a("el-button",{attrs:{slot:"append",type:"primary",icon:"el-icon-search"},on:{click:t.searchBackup},slot:"append"})],1)],1),a("el-button",{staticStyle:{"margin-bottom":"10px",float:"right"},attrs:{type:"primary"},on:{click:t.refreshPage}},[a("el-tooltip",{attrs:{content:"刷新",placement:"top-start"}},[a("i",{staticClass:"el-icon-refresh-right"})])],1),a("el-table",{directives:[{name:"loading",rawName:"v-loading",value:t.loadFlag,expression:"loadFlag"}],attrs:{data:t.backupList,"element-loading-text":"加载中"}},[a("el-table-column",{attrs:{label:"备份机名称",prop:"name"}}),a("el-table-column",{attrs:{label:"IP",prop:"host"}}),a("el-table-column",{attrs:{label:"服务端口",prop:"servicePort","min-width":"55"}}),a("el-table-column",{attrs:{label:"部署目录",prop:"installPath"}}),a("el-table-column",{attrs:{label:"数据目录",prop:"dataPath"}}),a("el-table-column",{attrs:{label:"版本号",prop:"version","min-width":"55"}}),a("el-table-column",{attrs:{label:"状态",prop:"status","min-width":"55"},scopedSlots:t._u([{key:"default",fn:function(e){return[0==e.row.status?a("span",{staticClass:"text-green"},[a("div",{staticClass:"green-bot"}),t._v("运行\n          ")]):1==e.row.status?a("span",{staticClass:"text-red"},[a("div",{staticClass:"red-bot"}),t._v("停止\n          ")]):a("span",{staticClass:"text-orange"},[a("div",{staticClass:"orange-bot"}),t._v("未知\n          ")])]}}])}),a("el-table-column",{attrs:{label:"创建时间",prop:"createTimestamp"}}),a("el-table-column",{attrs:{label:"操作"},scopedSlots:t._u([{key:"default",fn:function(e){return[a("el-button",{attrs:{type:"text",loading:t.deleteFlag},on:{click:function(a){return t.delBackup(e.row.pgBackupServerId)}}},[t._v(t._s(t.deleteFlag?"删除中":"删除"))]),a("el-dropdown",{staticStyle:{"margin-left":"10px","font-size":"12px"}},[a("span",{staticClass:"el-button--text"},[t._v("\n              更多\n            "),a("i",{staticClass:"el-icon-arrow-down el-icon--right"})]),a("el-dropdown-menu",{staticClass:"drop-menu",attrs:{slot:"dropdown"},slot:"dropdown"},[a("el-dropdown-item",[a("el-button",{staticStyle:{padding:"0 20px"},attrs:{type:"text",loading:t.startFlag},on:{click:function(a){return t.startBackupConfirm(e.row.pgBackupServerId)}}},[t._v(t._s(t.startFlag?"启动中":"启动"))])],1),a("el-dropdown-item",[a("el-button",{staticStyle:{padding:"0 20px"},attrs:{type:"text",loading:t.stopFlag},on:{click:function(a){return t.stopBackupConfirm(e.row.pgBackupServerId)}}},[t._v(t._s(t.stopFlag?"停止中":"停止"))])],1),a("el-dropdown-item",[a("el-button",{staticStyle:{padding:"0 20px"},attrs:{type:"text",loading:t.reloadFlag},on:{click:function(a){return t.reloadBackupConfirm(e.row.pgBackupServerId)}}},[t._v(t._s(t.reloadFlag?"重启中":"重启"))])],1)],1)],1)]}}])})],1),a("div",{staticStyle:{float:"right","margin-top":"10px","margin-bottom":"20px"}},[t.totalRecord>10?a("el-pagination",{attrs:{"page-size":t.pageSize,total:t.totalRecord,layout:"total, sizes, prev, pager, next, jumper"},on:{"size-change":t.handleSizeChange,"current-change":t.handleCurrentChange}}):t._e()],1),t.showList?a("create-backup",{on:{closeList:t.closeList}}):t._e(),t.showEditList?a("edit-backup",{on:{closeList:t.closeList}}):t._e()],1)])},n=[],s=(a("6b54"),a("2397"),a("7f7f"),a("96cf"),a("3b8d")),i=a("d225"),o=a("b0b4"),c=a("308d"),l=a("6bb5"),u=a("4e2b"),p=a("9ab4"),f=a("60a3"),d=a("e1ec"),m=a("4bb5"),h=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("el-dialog",{staticClass:"base-dialog",attrs:{title:"新增备份机",visible:!0,"before-close":t.onCancel,width:"700px"}},[a("el-form",{directives:[{name:"loading",rawName:"v-loading",value:t.loadingForm,expression:"loadingForm"}],ref:"form",attrs:{"element-loading-text":t.tipText,model:t.formData,rules:t.rules,"label-width":"120px",size:"medium"}},[a("el-form-item",{attrs:{label:"备份机名称",prop:"name"}},[a("el-input",{attrs:{placeholder:"请输入备份机名称"},model:{value:t.formData.name,callback:function(e){t.$set(t.formData,"name",e)},expression:"formData.name"}})],1),a("el-form-item",{attrs:{label:"IP地址",prop:"host"}},[a("el-select",{attrs:{filterable:"",placeholder:"请选择IP地址"},model:{value:t.formData.host,callback:function(e){t.$set(t.formData,"host",e)},expression:"formData.host"}},t._l(t.hostList,(function(t){return a("el-option",{key:t.value,attrs:{label:t.label,value:t.value}})})),1)],1),a("el-form-item",{attrs:{label:"服务端口",prop:"servicePort"}},[a("el-input",{attrs:{placeholder:"请输入服务端口"},model:{value:t.formData.servicePort,callback:function(e){t.$set(t.formData,"servicePort",e)},expression:"formData.servicePort"}})],1),a("el-form-item",{attrs:{label:"安装目录",prop:"installDir"}},[a("el-input",{attrs:{placeholder:"请输入安装目录"},model:{value:t.formData.installDir,callback:function(e){t.$set(t.formData,"installDir",e)},expression:"formData.installDir"}})],1),a("el-form-item",{attrs:{label:"数据目录",prop:"dataDir"}},[a("el-input",{attrs:{placeholder:"请输入数据目录"},model:{value:t.formData.dataDir,callback:function(e){t.$set(t.formData,"dataDir",e)},expression:"formData.dataDir"}})],1),a("el-form-item",{attrs:{label:"版本号",prop:"version"}},[a("el-select",{attrs:{placeholder:"请选择版本号"},model:{value:t.formData.version,callback:function(e){t.$set(t.formData,"version",e)},expression:"formData.version"}},t._l(t.versionList,(function(t){return a("el-option",{key:t.value,attrs:{label:t.label,value:t.value}})})),1)],1)],1),a("div",{staticClass:"dialog-footer",attrs:{slot:"footer"},slot:"footer"},[a("el-button",{attrs:{type:"primary"},on:{click:t.checkBackup}},[t._v("检查配置")]),a("el-button",{on:{click:t.onCancel}},[t._v("取 消")]),a("el-button",{attrs:{type:"primary"},on:{click:t.onSave}},[t._v("确 定")])],1)],1)},v=[];a("ac6a");function g(t){return function(){var e,a=Object(l["a"])(t);if(b()){var r=Object(l["a"])(this).constructor;e=Reflect.construct(a,arguments,r)}else e=a.apply(this,arguments);return Object(c["a"])(this,e)}}function b(){if("undefined"===typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"===typeof Proxy)return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],(function(){}))),!0}catch(t){return!1}}var k=function(t){Object(u["a"])(a,t);var e=g(a);function a(){var t;return Object(i["a"])(this,a),t=e.apply(this,arguments),t.formData={},t.loadingForm=!1,t.hostList=[],t.versionList=[],t.tipText="",t.rules={name:[{required:!0,message:"请输入备份机名称",trigger:"blur"}],host:[{required:!0,message:"请选择ip地址",trigger:"blur"}],servicePort:[{required:!0,message:"请输入服务端口",trigger:"blur"}],installDir:[{required:!0,message:"请输入安装目录",trigger:"blur"}],dataDir:[{required:!0,message:"请输入数据目录",trigger:"blur"}],version:[{required:!0,message:"请选择版本号",trigger:"blur"}]},t}return Object(o["a"])(a,[{key:"mounted",value:function(){this.getHostList(),this.getVersion()}},{key:"onCancel",value:function(){this.$emit("closeList")}},{key:"getHostList",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a,r=this;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,e={tenantId:this.data.paasConfig.userInfo.currentTenantId,name:"",type:1,pageNum:1,pageSize:100},t.next=4,d["a"].getHostList(e);case 4:a=t.sent,0===a.data.code&&a.data.data.list.forEach((function(t){r.hostList.push({label:t.name,value:t.pgHostId})})),t.next=10;break;case 8:t.prev=8,t.t0=t["catch"](0);case 10:return t.prev=10,t.finish(10);case 12:case"end":return t.stop()}}),t,this,[[0,8,10,12]])})));function e(){return t.apply(this,arguments)}return e}()},{key:"getVersion",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a=this;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,t.next=3,d["a"].getVersion();case 3:e=t.sent,0===e.data.code&&e.data.data.forEach((function(t){a.versionList.push({label:t,value:t})})),t.next=9;break;case 7:t.prev=7,t.t0=t["catch"](0);case 9:return t.prev=9,t.finish(9);case 11:case"end":return t.stop()}}),t,null,[[0,7,9,11]])})));function e(){return t.apply(this,arguments)}return e}()},{key:"checkBackup",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.tipText="检查配置中，请稍等...",this.loadingForm=!0,e={dataDir:this.formData.dataDir,name:this.formData.name,installDir:this.formData.installDir,pgHostId:this.formData.host,servicePort:this.formData.servicePort,version:this.formData.version},t.prev=3,t.next=6,d["a"].checkBackup(e);case 6:a=t.sent,0===a.data.code?a.data.data.success?(this.loadingForm=!1,this.$message.success("检测成功")):(this.loadingForm=!1,this.$message.error("检测失败，".concat(a.data.data.resultMsg))):(this.loadingForm=!1,this.$message.warning(a.data.msg),console.log(a.data.msg)),t.next=13;break;case 10:t.prev=10,t.t0=t["catch"](3),this.loadingForm=!1;case 13:return t.prev=13,t.finish(13);case 15:case"end":return t.stop()}}),t,this,[[3,10,13,15]])})));function e(){return t.apply(this,arguments)}return e}()},{key:"onSave",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.loadingForm=!0,this.tipText="新增中，请稍等...",e={dataDir:this.formData.dataDir,name:this.formData.name,installDir:this.formData.installDir,pgHostId:this.formData.host,servicePort:this.formData.servicePort,version:this.formData.version},t.prev=3,t.next=6,this.$refs.form.validate();case 6:return t.next=8,d["a"].createBackup(e);case 8:a=t.sent,0===a.data.code?(this.loadingForm=!1,this.$message.success("新增成功"),this.$emit("closeList")):(this.$message.warning(a.data.msg),this.loadingForm=!1),t.next=15;break;case 12:t.prev=12,t.t0=t["catch"](3),this.loadingForm=!1;case 15:return t.prev=15,t.finish(15);case 17:case"end":return t.stop()}}),t,this,[[3,12,15,17]])})));function e(){return t.apply(this,arguments)}return e}()}]),a}(f["c"]);Object(p["a"])([Object(m["a"])("data/getData")],k.prototype,"data",void 0),k=Object(p["a"])([f["a"]],k);var y=k,w=y,x=(a("bcb5"),a("2877")),D=Object(x["a"])(w,h,v,!1,null,"b4b4de1e",null),O=D.exports,B=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("el-dialog",{staticClass:"base-dialog",attrs:{title:"新增备份机",visible:!0,"before-close":t.onCancel,width:"600px"}},[a("el-form",{directives:[{name:"loading",rawName:"v-loading",value:t.loadingForm,expression:"loadingForm"}],ref:"form",attrs:{model:t.formData,"label-width":"80px",size:"medium"}},[a("el-form-item",{attrs:{label:"主机名"}},[a("el-input",{attrs:{placeholder:"请输入主机名"},model:{value:t.formData.name,callback:function(e){t.$set(t.formData,"name",e)},expression:"formData.name"}})],1),a("el-form-item",{attrs:{label:"IP地址"}},[a("el-input",{attrs:{type:"textarea",placeholder:"支持批量主机添加，多个IP地址使用英文逗号隔开。例如192.168.0.1,2000:0:0:0:0:0:0:1,localhost"},model:{value:t.formData.host,callback:function(e){t.$set(t.formData,"host",e)},expression:"formData.host"}})],1),a("el-form-item",{attrs:{label:"ssh用户名"}},[a("el-input",{attrs:{placeholder:"请输入ssh用户名"},model:{value:t.formData.sshUser,callback:function(e){t.$set(t.formData,"sshUser",e)},expression:"formData.sshUser"}})],1),a("el-form-item",{attrs:{label:"ssh密码"}},[a("el-input",{attrs:{type:"password",placeholder:"请输入ssh密码"},model:{value:t.formData.sshPwd,callback:function(e){t.$set(t.formData,"sshPwd",e)},expression:"formData.sshPwd"}})],1),a("el-form-item",{attrs:{label:"ssh端口"}},[a("el-input",{attrs:{placeholder:"请输入ssh端口"},model:{value:t.formData.sshPort,callback:function(e){t.$set(t.formData,"sshPort",e)},expression:"formData.sshPort"}})],1),a("el-form-item",{attrs:{label:"备注"}},[a("el-input",{attrs:{placeholder:"请输入备注"},model:{value:t.formData.remark,callback:function(e){t.$set(t.formData,"remark",e)},expression:"formData.remark"}})],1)],1),a("div",{staticClass:"dialog-footer",attrs:{slot:"footer"},slot:"footer"},[a("el-button",{attrs:{type:"primary"},on:{click:t.checkSet}},[t._v("检查配置")]),a("el-button",{on:{click:t.onCancel}},[t._v("取 消")]),a("el-button",{attrs:{type:"primary"},on:{click:t.onSave}},[t._v("确 定")])],1)],1)},j=[],S=(a("8e6e"),a("456d"),a("bd86"));function $(t,e){var a=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),a.push.apply(a,r)}return a}function _(t){for(var e=1;e<arguments.length;e++){var a=null!=arguments[e]?arguments[e]:{};e%2?$(Object(a),!0).forEach((function(e){Object(S["a"])(t,e,a[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(a)):$(Object(a)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(a,e))}))}return t}function L(t){return function(){var e,a=Object(l["a"])(t);if(R()){var r=Object(l["a"])(this).constructor;e=Reflect.construct(a,arguments,r)}else e=a.apply(this,arguments);return Object(c["a"])(this,e)}}function R(){if("undefined"===typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"===typeof Proxy)return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],(function(){}))),!0}catch(t){return!1}}var F=function(t){Object(u["a"])(a,t);var e=L(a);function a(){var t;return Object(i["a"])(this,a),t=e.apply(this,arguments),t.formData={},t.loadingForm=!1,t}return Object(o["a"])(a,[{key:"mounted",value:function(){}},{key:"onCancel",value:function(){this.$emit("closeList")}},{key:"checkSet",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.loadingForm=!0,e=_({},this.formData),t.prev=2,t.next=5,d["a"].checkSet(e);case 5:a=t.sent,0===a.data.code?(this.loadingForm=!1,this.$message.success("检测成功")):(this.loadingForm=!1,this.$message.warning(a.data.msg),console.log(a.data.msg)),t.next=13;break;case 9:t.prev=9,t.t0=t["catch"](2),this.$message.warning("检测失败"),console.log(t.t0);case 13:return t.prev=13,t.finish(13);case 15:case"end":return t.stop()}}),t,this,[[2,9,13,15]])})));function e(){return t.apply(this,arguments)}return e}()},{key:"onSave",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.loadingForm=!0,e=_({},this.formData),t.prev=2,t.next=5,d["a"].createHost(e);case 5:a=t.sent,0===a.data.code?(this.loadingForm=!1,this.$message.success("新增成功"),this.$emit("closeList")):(this.$message.warning(a.data.msg),console.log(a.data.msg),this.loadingForm=!1),t.next=13;break;case 9:t.prev=9,t.t0=t["catch"](2),this.$message.warning("新增失败"),console.log(t.t0);case 13:return t.prev=13,t.finish(13);case 15:case"end":return t.stop()}}),t,this,[[2,9,13,15]])})));function e(){return t.apply(this,arguments)}return e}()}]),a}(f["c"]);Object(p["a"])([Object(f["b"])(Object)],F.prototype,"detilList",void 0),F=Object(p["a"])([f["a"]],F);var P=F,C=P,I=(a("e1b0"),Object(x["a"])(C,B,j,!1,null,"5925dbce",null)),z=I.exports;function T(t){return function(){var e,a=Object(l["a"])(t);if(E()){var r=Object(l["a"])(this).constructor;e=Reflect.construct(a,arguments,r)}else e=a.apply(this,arguments);return Object(c["a"])(this,e)}}function E(){if("undefined"===typeof Reflect||!Reflect.construct)return!1;if(Reflect.construct.sham)return!1;if("function"===typeof Proxy)return!0;try{return Date.prototype.toString.call(Reflect.construct(Date,[],(function(){}))),!0}catch(t){return!1}}var q=function(t){Object(u["a"])(a,t);var e=T(a);function a(){var t;return Object(i["a"])(this,a),t=e.apply(this,arguments),t.rowData={},t.totalRecord=0,t.pageSize=10,t.pageIndex=1,t.name="",t.showEditList=!1,t.showList=!1,t.backupList=[],t.loadFlag=!1,t.deleteFlag=!1,t.startFlag=!1,t.reloadFlag=!1,t.stopFlag=!1,t}return Object(o["a"])(a,[{key:"createBackup",value:function(){this.showList=!0}},{key:"getBackList",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(){var e,a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.loadFlag=!0,t.prev=1,e={name:this.name,pageNow:this.pageIndex,pageSize:this.pageSize},t.next=5,d["a"].getBackList(e);case 5:a=t.sent,0===a.data.code?(this.loadFlag=!1,this.backupList=a.data.data.list,this.totalRecord=a.data.data.total):(this.loadFlag=!1,this.$message.warning("获取数据失败，".concat(a.data.msg))),t.next=11;break;case 9:t.prev=9,t.t0=t["catch"](1);case 11:return t.prev=11,t.finish(11);case 13:case"end":return t.stop()}}),t,this,[[1,9,11,13]])})));function e(){return t.apply(this,arguments)}return e}()},{key:"delBackup",value:function(t){var e=this;this.$confirm("是否确认删除该备份机？","删除备份机",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then((function(){e.deleteBackup(t)})).catch((function(){}))}},{key:"deleteBackup",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(e){var a,r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,a={backupServerId:e},t.next=4,d["a"].deleteBackup(a);case 4:r=t.sent,0===r.data.code?(this.$message.success("删除成功"),this.getBackList()):this.$message.warning("删除失败，".concat(r.data.msg)),t.next=11;break;case 8:t.prev=8,t.t0=t["catch"](0),this.$message.warning("删除失败,".concat(t.t0));case 11:return t.prev=11,t.finish(11);case 13:case"end":return t.stop()}}),t,this,[[0,8,11,13]])})));function e(e){return t.apply(this,arguments)}return e}()},{key:"startBackupConfirm",value:function(t){var e=this;this.$confirm("是否确认启动该备份机？","启动备份机",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then((function(){e.startBackup(t)})).catch((function(){}))}},{key:"startBackup",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(e){var a,r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,a={backupServerId:e},t.next=4,d["a"].startBackup(a);case 4:r=t.sent,0===r.data.code?(this.$message.success("启动成功"),this.getBackList()):this.$message.warning("启动失败，".concat(r.data.msg)),t.next=11;break;case 8:t.prev=8,t.t0=t["catch"](0),this.$message.warning("启动失败,".concat(t.t0));case 11:return t.prev=11,t.finish(11);case 13:case"end":return t.stop()}}),t,this,[[0,8,11,13]])})));function e(e){return t.apply(this,arguments)}return e}()},{key:"stopBackupConfirm",value:function(t){var e=this;this.$confirm("是否确认停止该备份机？","停止备份机",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then((function(){e.stopBackup(t)})).catch((function(){}))}},{key:"stopBackup",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(e){var a,r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,a={backupServerId:e},t.next=4,d["a"].stopBackup(a);case 4:r=t.sent,0===r.data.code?(this.$message.success("停止成功"),this.getBackList()):this.$message.warning("停止失败，".concat(r.data.msg)),t.next=11;break;case 8:t.prev=8,t.t0=t["catch"](0),this.$message.warning("停止失败,".concat(t.t0));case 11:return t.prev=11,t.finish(11);case 13:case"end":return t.stop()}}),t,this,[[0,8,11,13]])})));function e(e){return t.apply(this,arguments)}return e}()},{key:"reloadBackupConfirm",value:function(t){var e=this;this.$confirm("是否确认重启该备份机？","重启备份机",{confirmButtonText:"确定",cancelButtonText:"取消",type:"warning"}).then((function(){e.restartBackup(t)})).catch((function(){}))}},{key:"restartBackup",value:function(){var t=Object(s["a"])(regeneratorRuntime.mark((function t(e){var a,r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return t.prev=0,a={backupServerId:e},t.next=4,d["a"].restartBackup(a);case 4:r=t.sent,0===r.data.code?(this.$message.success("重启成功"),this.getBackList()):this.$message.warning("重启失败，".concat(r.data.msg)),t.next=11;break;case 8:t.prev=8,t.t0=t["catch"](0),this.$message.warning("重启失败,".concat(t.t0));case 11:return t.prev=11,t.finish(11);case 13:case"end":return t.stop()}}),t,this,[[0,8,11,13]])})));function e(e){return t.apply(this,arguments)}return e}()},{key:"searchBackup",value:function(){this.getBackList()}},{key:"refreshPage",value:function(){this.getBackList()}},{key:"closeList",value:function(){this.getBackList(),this.showList=!1,this.showEditList=!1}},{key:"handleSizeChange",value:function(t){this.pageSize=t,this.getBackList()}},{key:"handleCurrentChange",value:function(t){this.pageIndex=t,this.getBackList()}},{key:"mounted",value:function(){this.getBackList()}}]),a}(f["c"]);Object(p["a"])([Object(m["a"])("data/getData")],q.prototype,"data",void 0),q=Object(p["a"])([Object(f["a"])({components:{createBackup:O,editBackup:z}})],q);var H=q,N=H,V=(a("2b4a"),Object(x["a"])(N,r,n,!1,null,"69d7c091",null));e["default"]=V.exports},bcb5:function(t,e,a){"use strict";var r=a("46a3"),n=a.n(r);n.a},bd86:function(t,e,a){"use strict";a.d(e,"a",(function(){return s}));var r=a("85f2"),n=a.n(r);function s(t,e,a){return e in t?n()(t,e,{value:a,enumerable:!0,configurable:!0,writable:!0}):t[e]=a,t}},c949:function(t,e,a){"use strict";var r=a("6073"),n=a.n(r),s=n.a.http;e["a"]=s},e1b0:function(t,e,a){"use strict";var r=a("4fe6"),n=a.n(r);n.a},e1ec:function(t,e,a){"use strict";var r=a("c949"),n=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/host/list",{params:t})},s=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/backup_server/pageQuery",{params:t})},i=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/backup_server/list",{params:t})},o=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/delete?backupServerId=".concat(t.backupServerId))},c=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/restart?backupServerId=".concat(t.backupServerId))},l=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/stop?backupServerId=".concat(t.backupServerId))},u=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/start?backupServerId=".concat(t.backupServerId))},p=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/backup_server/versions",{params:t})},f=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/checkConfig",t)},d=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].post("/backup_server/create",t)},m=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/backup_server/queryBindBackupServer",{params:t})},h=function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return r["a"].get("/backup_server/saveBindRel",{params:t})};e["a"]={getBackList:s,deleteBackup:o,restartBackup:c,stopBackup:l,startBackup:u,getVersion:p,checkBackup:f,createBackup:d,getBackupData:i,getHostList:n,queryBindBackupServer:m,bindBackupServer:h}},f1ae:function(t,e,a){"use strict";var r=a("86cc"),n=a("4630");t.exports=function(t,e,a){e in t?r.f(t,e,n(0,a)):t[e]=a}}}]);