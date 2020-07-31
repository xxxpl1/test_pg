/**
 * Created by 卢吉 on 2019/7/22.
 */
function hover(ele, over, out) {
  ele.addEventListener('mouseover', over, false);
  ele.addEventListener('mouseout', out, false);
}
// var IP = apiIp
var isOps = false
var IP = ''
var cUrl = ''
var accountHref = ''
var sysadminHref = ''
var companyHref = ''
var orderHref = ''
var logoHref = ''
var titleHref = ''
var notifyHref = ''
var pathNames = window.location.pathname && window.location.pathname.split('/').filter(function (el) {
  return el !== '';
});
var navList = [
  {
    label: '',
    icon: 'icon-sub',
    sub: [
    ]
  }
];
var notifyNum = 0;
function getQueryString(paras) {
  var url = location.href;
  var paraString = url.substring(url.indexOf("?") + 1, url.length).split("&");
  var paraObj = {}
  for (var i = 0; j = paraString[i]; i++) {
    paraObj[j.substring(0, j.indexOf("="))] = j.substring(j.indexOf("=") + 1, j.length);
  }
  var returnValue = paraObj[paras];
  if (typeof(returnValue) == "undefined") {
    return "";
  } else {
    return returnValue;
  }
}
var layout = {
  init: function (option,ele) {
    isOps = option.type === 'ops';
    IP = isOps ? commonConfig.gatewayOpsUrl : commonConfig.gatewayUrl
    
    cUrl = IP + '/gw/regions/choose'
    accountHref = commonConfig.portalUrl + '/' +  pathNames[pathNames.length - 1].replace('/', '') + '/sysmgr.html#/user-center'
    sysadminHref = commonConfig.portalUrl + '/' + pathNames[pathNames.length - 1].replace('/', '') + '/sysmgr.html'
    console.log(sysadminHref)
    if(!option){
      option = {}
    }
    if(option.cUrl){
      // cUrl = option.cUrl
    }
    var RegionId = sessionStorage.getItem('regionid')
    if (!RegionId || RegionId =='null') {
      RegionId = getQueryString('regionid')
    }
    var accountId = ''
    if(option.user.accountId){
      accountId = option.user.accountId
    }else{
      accountId = sessionStorage.getItem('accountid')
      if (!accountId || accountId =='null') {
        accountId = getQueryString('accountid')
      }
    }
    sessionStorage.setItem('regionid', RegionId)
    sessionStorage.setItem('accountid', accountId)
    option['RegionId'] = RegionId
    option['accountId'] = accountId
    var header = this.createHead(option);
    var footer = this.creatFooter();
    if (ele) {
      ele.appendChild(header);
      ele.appendChild(footer);
    } else {
      //插入到body
      var body = document.getElementsByTagName('body')[0];
      body.appendChild(header);
      // body.appendChild(footer);
      // var error = document.createElement('div');
      // error.id='chooseRegionError'
      // var msg=document.createElement('div');
      // var close=document.createElement('button');
      // msg.innerHTML='error'
      // close.innerHTML='关闭'
      // close.onclick=function(){
      //     var chooseRegionError=document.getElementById('chooseRegionError')
      //     chooseRegionError.style.display='none'
      // }
      // error.appendChild(msg);
      // error.appendChild(close);
      // body.appendChild(error);
    }
    
  },
  createHead: function (option) {
    return this.creatElement(option);
  },
  creatElement: function (option) {
    var head = document.createElement('div');
    head.className = 'console-header';
    head.appendChild(this.creatLeft(option));
    head.appendChild(this.creatRight(option));
    return head;
  },
  creatLeft: function (option) {
    var headerLeft = document.createElement('div');
    headerLeft.className = 'header-left';

    var logo = document.createElement('div');
    logo.className = 'logo';
    logo.onclick = function () {
      // location.href = logoHref
    }
    // var img = document.createElement('img');
    // img.src = IP + '/static/share/logo.png';
    // logo.appendChild(img);

    // 运维测不出现左上角apps
    if (!isOps) {
      // var dropdown = document.createElement('div');
      // dropdown.className = 'console-dropdown';
      // var ul = document.createElement('ul');
      // ul.className = 'navList';
      // var _this = this;
      // navList.forEach(function (item) {
      //   var li = document.createElement('li');
      //   if (item.sub) {
      //     li.className = 'subnav nav';
      //     var label = document.createElement('label');
      //     label.className = 'navlabel';
      //     // var server = document.createElement('span');
      //     // server.className = 'name';
      //     // server.innerHTML = '服务列表'
      //     var svgh = document.createElement('span');
      //     svgh.className = 'icon-list';
      //     // label.appendChild(server);
      //     label.appendChild(svgh);
      //     var secondNav = document.createElement('div');
      //     secondNav.className = 'secondNav hide';

      //     var listNav = document.createElement('div');
      //     listNav.className = 'listNav';

      //     // var secondNav=document.createElement('div');
      //     // secondNav.className='secondNav hide';
      //     listNav.appendChild(_this.secondNav(item.sub));
      //     secondNav.appendChild(listNav);

      //     li.appendChild(label);
      //     li.appendChild(secondNav);
      //     hover(li, function () {
      //       secondNav.className = 'secondNav show';
      //     }, function () {
      //       secondNav.className = 'secondNav hide';
      //     })
      //   } else {
      //     li.className = 'nav';
      //     var label = document.createElement('label');
      //     var span = document.createElement('span');
      //     var svg = document.createElement('span');
      //     svg.className = item.icon;
      //     span.innerHTML = item.label;
      //     label.appendChild(svg);
      //     label.appendChild(span);
      //     li.appendChild(label);
      //     li.onclick = function () {
      //       window.location.href = item.path
      //     }


      //   }
      //   ul.appendChild(li);
      // })
      // dropdown.appendChild(ul);

      // headerLeft.appendChild(dropdown);

      
    }
  

    var center = document.createElement('div');
    center.className = 'center'
    
    center.onclick = function () {
      // location.href = titleHref
      // window.location.reload();
    }


    var xhrd = new XMLHttpRequest();
    xhrd.open('get', IP + '/' + option.ctxPath.replace('/', '') + '/iam/users/current/sysTitle');
    xhrd.setRequestHeader('content-type', 'application/json');
    xhrd.withCredentials = true
    xhrd.send();
    xhrd.onreadystatechange = function () {
      if (xhrd.readyState == 4 && xhrd.status == 200) {
        var result = JSON.parse(xhrd.responseText)
        center.innerHTML = result.componentTitle
        headerLeft.appendChild(center);
      }
    }
    headerLeft.appendChild(logo);
    


    
    
    return headerLeft
  },
  secondNav: function (data) {
    var ul = document.createElement('ul');
    ul.className = 'listApp';
    data.forEach(function (item) {
      var li = document.createElement('li');
      if (item.group) {
        if (item.class) {
          li.className = item.class;
        } else {
          li.className = 'li';
        }
        var label = document.createElement('label');
        label.innerHTML = item.label;
        li.appendChild(label);
        item.group.forEach(function (val) {
          var div = document.createElement('div');
          if (val.type) {
            div.className = val.type
          }

          var span = document.createElement('span');
          var svg = document.createElement('span');
          span.innerHTML = val.label;
          svg.className = val.icon;
          // div.appendChild(svg);
          div.appendChild(span);
          if (val.class) {
            div.className = val.class
          } else {
            div.onclick = function () {
              location.href = val.path;
            };
          }
          li.appendChild(div);
        })
      } else {
        li.className = 'firstNav';
        var div = document.createElement('div');
        var span = document.createElement('span');
        var svg = document.createElement('span');
        span.innerHTML = item.label;
        svg.className = item.icon;
        div.appendChild(svg);
        div.appendChild(span);
        div.onclick = function () {
          location.href = item.path;
        };
        li.appendChild(div);
      }

      ul.appendChild(li);
    });
    return ul;
  },
  dateFormate: function(time) {
    var date = new Date(time);
      Y = date.getFullYear() + '-';
      M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
      D = (date.getDate() < 10 ? '0' + date.getDate() : date.getDate()) + ' ';
      h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
      m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
      s = (date.getSeconds() < 10 ? '0' + date.getSeconds() : date.getSeconds())  
    return Y + M + D + h + m + s
  },
  postDataFormat: function(obj){
     // 支持有FormData的浏览器（Firefox 4+ , Safari 5+, Chrome和Android 3+版的Webkit）
     if (typeof FormData == "function") {
        var data = new FormData();
        for (var attr in obj) {
            data.append(attr, obj[attr]);
        }
        return data;
      } else {
        // 不支持FormData的浏览器的处理 
        var arr = new Array();
        var i = 0;
        for (var attr in obj) {
          arr[i] = encodeURIComponent(attr) + "=" + encodeURIComponent(obj[attr]);
          i++;
        }
        return arr.join("&");
      }
  },
  getNotify: function (notifyType, ul, option) {
    var xhr = new XMLHttpRequest();
    xhr.open('get', IP + '/cloudportal/oms/userNotify?userAccount=' + option.user.userName+'&userType='+ (isOps ? 0 : 1)+ '&notifyType=' + notifyType);
    xhr.withCredentials = true
    xhr.send()
    var that = this;
    xhr.onreadystatechange = function () {
      if (xhr.readyState == 4 && xhr.status == 200) {
        var data = JSON.parse(xhr.responseText).data
        ul.innerHTML = '';
        var sum = 0;
        if (data && data.length !== 0) {
          data.forEach(function (item, index) {
            var li
            li = document.createElement('li');
            var p = document.createElement('p');
            p.className = 'li-top'
            
            if (item.isRead !== 1){
              var i = document.createElement('i')
              i.className = 'dot'
              p.appendChild(i)
              ++sum;
              ++notifyNum;
            }
            var span = document.createElement('span')
            span.className = 'title'
            span.innerText = item.title
            
            p.appendChild(span)
            var pTime = document.createElement('p');
            pTime.className = 'li-bottom'
            pTime.innerText = that.dateFormate(item.createdTime)
            li.appendChild(p)
            li.appendChild(pTime)

            li.onclick = function(){
              var xhrM = new XMLHttpRequest();
              xhrM.open('post', IP + '/cloudportal/oms/userNotify/read');
              xhrM.setRequestHeader('content-type', 'application/json');
              xhrM.withCredentials = true
              xhrM.send(JSON.stringify({
                notifyId: item.notifyId,
                id: item.id,
                isRead: item.isRead,
                userAccount: option.user.userName
              }))
              xhrM.onreadystatechange = function () {
                window.location.href = notifyHref + item.notifyId
                if (window.location.href.indexOf('cloudportal') > -1) {
                  window.location.reload()
                }
              }
            }
            document.getElementsByClassName(ul)[0].appendChild(li)
          })
          
          if (notifyType === 1) {
            if (sum === 0) {
              document.getElementsByClassName('gg_num')[0].className = 'num gg_num hide'
            } else {
              document.getElementsByClassName('gg_num')[0].innerText = sum
            }
          }else {
            if (sum === 0) {
              document.getElementsByClassName('xx_num')[0].className = 'num xx_num hide'
            } else {
              document.getElementsByClassName('xx_num')[0].innerText = sum
            }
          }
        } else {
          if (notifyType === 1) {
            document.getElementsByClassName('gg_num')[0].className = 'num gg_num hide'
          }else {
            document.getElementsByClassName('xx_num')[0].className = 'num xx_num hide'
          }
          var li = document.createElement('li');
          li.className = 'no-data'
          li.innerHTML ='暂无数据'
          document.getElementsByClassName(ul)[0].appendChild(li)
        }
        if (notifyNum === 0) {
          document.getElementsByClassName('notify-num')[0].className = 'notify-num hide'
        } else {
          document.getElementsByClassName('notify-num')[0].innerText = notifyNum
        }
        
      }
    }
  },
  creatRight: function (option) {
    var headerRight = document.createElement('div');
    headerRight.className = 'header-right';


    // 租户start
    // 运维测不出现租户
    if(!isOps) {
      var listT = document.createElement('div');
      listT.className = "node-list tenant-list";
      var selectedT = document.createElement('div');
      selectedT.className = 'nodes'
      listT.appendChild(selectedT);
      var addressT = document.createElement('span');
      addressT.className = 'address'
      var addressiconT = document.createElement('span');
      addressiconT.className = 'headerIcons iconperson2'
      addressT.appendChild(addressiconT)
      var nodeT = document.createElement('span');
      nodeT.className = 'node'
      nodeT.innerHTML = option.user.currentTenantName || '无'
      var iconT = document.createElement('span');
      iconT.className = 'iconDown'
      // var iconImgT = document.createElement('span');
      // iconImgT.className = 'icon-list'
      // iconT.appendChild(iconImgT)
      selectedT.appendChild(addressT);
      selectedT.appendChild(nodeT);
      selectedT.appendChild(iconT);
      var ulListT = document.createElement('ul');
      ulListT.className = 'select hide';
      listT.appendChild(ulListT);

      selectedT.onclick = function (event) {
        event = event || window.event
        ulList.className = 'select hide'
        event.stopPropagation()
        if (ulListT.className == 'select hide') {
          addressT.className = 'address addressBlue'
          ulListT.className = 'select show'
        } else {
          addressT.className = 'address'
          ulListT.className = 'select hide'
        }
        // infoListT.className = 'infoList hide'
      };
      // 渲染租户结构
      option.user.tenants && option.user.tenants.forEach(function (item, index) {
        var li
        li = document.createElement('li');
        var span = document.createElement('span');
        span.innerHTML = item.tenantName
        li.appendChild(span)
        ulListT.appendChild(li)

        li.onclick = function () {
          var xhrd = new XMLHttpRequest();
          xhrd.open('post', IP + '/'+ option.ctxPath.replace('/','') + '/iam/users/current/tenants/' + item.tenantId);
          xhrd.setRequestHeader('content-type', 'application/json');
          xhrd.withCredentials = true
          xhrd.send(JSON.stringify({
            tenantName: item.tenantName
          }));
          xhrd.onreadystatechange = function () {
            if (xhrd.readyState == 4 && xhrd.status == 200) {
              window.location.reload()
            }
          }
        }
      })
      headerRight.appendChild(listT);
    }
    // 租户end

    var address = document.createElement('span');
    address.className = 'address'
    var addressicon = document.createElement('span');
    addressicon.className = 'headerIcons iconresources'
    address.appendChild(addressicon)

    

    var node = document.createElement('span');
    node.className = 'node'
    node.innerHTML = ''

    var icon = document.createElement('span');
    icon.className = 'iconDown'
    // var iconImg = document.createElement('span');
    // iconImg.className = 'headerIcons headerIcons iconNavigation-expandthesecondarymenuarrow'
    // icon.appendChild(iconImg)


    var ulList = document.createElement('ul');


    var user = document.createElement('div');
    user.className = 'user';

    var useShow = document.createElement('div');
    useShow.className = 'useShow';

    var userImg = document.createElement('span');
    userImg.className = 'userImg';
    var img = null;
    if (option.user.avatar) {
      img = document.createElement('img');
      img.src = IP + (isOps ? '/cloudmgr' : '/cloudportal') + '/oms/attach/showImage?imagePath=' + option.user.avatar
    }else {
      img = document.createElement('div');
    }
    userImg.appendChild(img)

    var userList = document.createElement('span');
    userList.className = 'userList'
    var name = document.createElement('span');
    name.className = 'userName'

    var sanjiao = document.createElement('span');
    sanjiao.className = 'iconDown'
    userList.appendChild(name)
    userList.appendChild(sanjiao)

    useShow.appendChild(userImg)
    useShow.appendChild(userList)

    var infoList = document.createElement('ul');
    infoList.className = 'infoList hide'

    var my_account = document.createElement('li');
    my_account.className = 'my_account'
    var my_account_a = document.createElement('a');
    my_account_a.innerHTML = '用户中心'
    my_account.appendChild(my_account_a)

    if (option.user.accountType == 1) {
      var my_sysadmin = document.createElement('li');
      my_sysadmin.className = 'my_sysadmin'
      var my_sysadmin_a = document.createElement('a');
      my_sysadmin_a.innerHTML = '系统管理'
      my_sysadmin_a.href = sysadminHref
      my_sysadmin_a.target = '_blank'
      my_sysadmin.appendChild(my_sysadmin_a)
    }
    var logout = document.createElement('li');
    logout.className = 'logout'
    var logout_a = document.createElement('a');
    logout_a.innerHTML = '退出登录'
    // logout_a.href = IP + '/logout'
    logout_a.onclick = function () {
      var xhrM = new XMLHttpRequest();
      xhrM.open('delete', IP + '/' + option.ctxPath.replace('/', '')  + '/logout');
      xhrM.setRequestHeader('content-type', 'application/json');
      xhrM.withCredentials = true
      xhrM.send()
      xhrM.onreadystatechange = function () {
        if (xhrM.readyState == 4 && xhrM.status == 200) {
          var result = JSON.parse(xhrM.responseText)
          window.location.href = result.loginUrl
        }
        
      }
    }
    logout.appendChild(logout_a)

    infoList.appendChild(my_account)
    if (option.user.accountType == 1) {
      infoList.appendChild(my_sysadmin)
    }
    
    infoList.appendChild(logout)


    user.appendChild(useShow)
    user.appendChild(infoList)

    var msg = document.createElement('div');
    msg.className = 'msg'
    var msg_a = document.createElement('a');
    msg_a.href = '#'
    var msg_img = document.createElement('span');
    msg_img.className = 'icon-msg'
    msg_a.appendChild(msg_img)
    msg.appendChild(msg_a)

    var quota = document.createElement('div');
    quota.className = 'quota'
    var quota_a = document.createElement('a');
    var quota_img = document.createElement('span');
    quota_img.className = 'icon-quota'
    quota_a.appendChild(quota_img)
    quota.appendChild(quota_a)


    // var help = document.createElement('div');
    // help.className = 'help'
    // var help_a = document.createElement('a');
    // var help_img = document.createElement('span');
    // help_img.className = 'icon-help'
    // help_a.appendChild(help_img)
    // help.appendChild(help_a)
    
    name.innerHTML = option.user.realName ||  '未知'
    my_account_a.href = accountHref || ''
    my_account_a.target = '_blank'
    
    // var xhr = new XMLHttpRequest();
    // xhr.open('get', IP + '/console/index/user/?regionid=all&accountId=' + option.accountId);
    // xhr.send();
    // xhr.onreadystatechange = function () {
    //   if (xhr.readyState == 4 && xhr.status == 200) {
    //     var data = JSON.parse(xhr.responseText);
    //     name.innerHTML = data.customer_name ? data.customer_name : 'admin'
    //     my_account_a.href = data.my_account_url
    //     my_order_a.href = data.my_order_url
    //     my_services_a.href = data.my_services_url
    //     my_beian_a.href = data.my_beian_url
    //     quota_a.href = data.my_quota_url
    //     // help_a.href = data.my_help_url


    //   }
    // }
    //用户信息

    // var info=document.createElement('ul');
    // info.className='hide';
    // var licenter=document.createElement('li');
    // var liout=document.createElement('li');
    // var center=document.createElement('a');
    // // center.href='www.ctyun.cn';
    // licenter.onclick=function(){
    //     window.location.href='http://www.ctyun.cn'
    // }
    // center.innerHTML='个人中心'
    // var out=document.createElement('a');
    // out.href='http://36.111.164.230:83/logout';
    // out.innerHTML='退出登录'
    //
    // info.appendChild(licenter);
    // info.appendChild(liout);
    // licenter.appendChild(center);
    // liout.appendChild(out);
    // use.appendChild(span);
    // use.appendChild(info);


    // headerRight.appendChild(list);
    headerRight.appendChild(user);
    // headerRight.appendChild(msg);
    // headerRight.appendChild(quota);
    // headerRight.appendChild(help);

    document.addEventListener('click', function () {
      address.className = 'address'
      document.getElementsByClassName('select')[0].className = 'select hide'
      // 运维测没有租户下拉
      // if (!isOps) {
      //   document.getElementsByClassName('select')[1].className = 'select hide'
      // }
      address.className = 'address'
      // 运维测没有租户
      if(!isOps) {
        addressT.className = 'address'
      }
      // document.getElementsByClassName('nodeInfo')[0].className = 'nodeInfo hide'
      infoList.className = 'infoList hide'
    })
    ulList.onclick = function (event) {
      event = event || window.event
      event.stopPropagation()
    };
    // nodeInfo.onclick = function (event) {
    //   event = event || window.event
    //   event.stopPropagation()
    // };

    useShow.onclick = function (event) {
      event = event || window.event
      event.stopPropagation()
      if (infoList.className == 'infoList show') {
        infoList.className = 'infoList hide'
      } else {
        infoList.className = 'infoList show'
      }
      ulList.className = 'select hide'
      if (!isOps) {
        ulListT.className = 'select hide'
      }
      address.className = 'address'

    }
    infoList.onclick = function (event) {
      event = event || window.event
      event.stopPropagation()
      infoList.className = 'infoList hide'
    };

    function fiterStack(data, fiter) {
      for (var i = 0; i < data.length; i++) {
        data[i].style.display = fiter;
      }
    }

    function passClick(adress) {
      window.location.href = adress;
      // alert(adress)
    }

    function filterPaas(data) {
      for (var i in data) {
        var pass = document.getElementsByClassName(i)[0];
        pass.className = i + ' show';
        (function (i) {
          pass.onclick = function () {
            passClick(data[i])
          }
        })(i)
      }
    }

    function onSelectedNode(data, nodelist) {
      // document.getElementsByClassName('select')[0].className = 'select hide'
      // document.getElementsByClassName('nodeInfo')[0].className = 'nodeInfo show'
      // nodelist.innerHTML = ''
      // var li
      // data.platforms.forEach(function (item, index) {
      //   li = document.createElement('li')
      //   var a
      //   if (item.ctyun == 0) {
      //     a = document.createElement('span')
      //     a.onclick = function () {
      //       onSelected(item)
      //     }
      //   } else {
      //     a = document.createElement('a')
      //     a.href = item.zoneUrl
      //   }

      //   a.innerHTML = item.zoneName
      //   li.appendChild(a)
      //   nodelist.appendChild(li)
      // })

    }

    function replaceParamVal(paramName,replaceWith) {
      var oUrl = this.location.href.toString();
      var url = oUrl.split('?')
      var re = eval('/(' + paramName + '=)([^&]*)/gi');
      var nUrl = ''
      if (url[1] && url[1].indexOf("RegionId") != -1) {
        nUrl = url[1].replace(re, paramName + '=' + replaceWith);
        nUrl = url[0] + "?" + nUrl;
      } else {
        if (url[1]) {
          nUrl = url[0] + '?RegionId=' +replaceWith + '&' + url[1]
        } else {
          nUrl = url[0] + '?RegionId=' + replaceWith
        }
      }
      window.location.href = nUrl
      window.location.reload()
     }


    function onSelected(item){
      if (option.chooseRegion) {
        var xhrd = new XMLHttpRequest();
        xhrd.open('post', cUrl + '?region=' + item.resPoolCode);
        xhrd.withCredentials = true
        xhrd.send();
        xhrd.onreadystatechange = function () {
          if (xhrd.readyState == 4 && xhrd.status == 200) {
            var result = JSON.parse(xhrd.responseText)
            if (result.statusCode == 800) {
              option.chooseRegion(result)
              // if (item.ctyun == 0) {
              //   sessionStorage.setItem('regionid', item.uuid);
              //   replaceParamVal("RegionId", item.uuid)
              // } else {
              //   window.location.href = item.zoneUrl
              // }
              sessionStorage.setItem('regionid', item.resPoolCode);
              replaceParamVal("RegionId", item.resPoolCode)
              window.location.reload();
            } else {
              showError(result)
            }
          }
        }
      } else {
        if (item.ctyun == 0) {
          sessionStorage.setItem('regionid', item.resPoolCode);
          replaceParamVal("RegionId", item.resPoolCode)
        } else {
          window.location.href = item.zoneUrl
        }
      }
            

    }


    // hover(span,function(){
    //     info.className='show';
    // },function(){
    //     info.className='hide';
    // })
    // span.onhover=function(){
    //
    // };
    // hover(info,function(){
    //     info.className='show';
    // },function(){
    //     info.className='hide';
    // })
    // span.onhover=function(){
    //
    // };
    return headerRight
  },

  creatFooter: function () {
    var footer = document.createElement('div');
    var left = document.createElement('div');
    left.className = 'left'

    var left_leftg = document.createElement('span');
    left_leftg.className = 'footer-font'
    var left_img = document.createElement('span');
    left_img.className = 'icon-footerIcon'
    left_leftg.appendChild(left_img)
    var left_span = document.createElement('span');
    left_span.innerHTML = '中文（简体）'
    left.appendChild(left_leftg)
    left.appendChild(left_span)

    var right = document.createElement('div');
    right.className = 'right'
    var beian = document.createElement('span');
    beian.innerHTML = '© 2019中国电信股份有限公司云计算分公司版权所有'
    // var index = document.createElement('a');
    // index.innerHTML = '天翼云首页'
    // index.href = 'http://www.ctyun.cn/'
    // var portal = document.createElement('a');
    // portal.innerHTML = '用户协议'
    // portal.href = 'http://www.ctyun.cn/terms'
    // var falv = document.createElement('a');
    // falv.innerHTML = '法律声明'
    // falv.href = 'http://www.ctyun.cn/law'
    // var line1 = document.createElement('span');
    // line1.className = 'line'
    // var line2 = document.createElement('span');
    // line2.className = 'line'
    // var line3 = document.createElement('span');
    // line3.className = 'line'
    right.appendChild(beian)
    // right.appendChild(line1)
    // right.appendChild(index)
    // right.appendChild(line2)
    // right.appendChild(portal)
    // right.appendChild(line3)
    // right.appendChild(falv)

    footer.appendChild(left)
    footer.appendChild(right)
    footer.className = 'console-footer';
    // footer.innerHTML='©2018中国电信股份有限公司云计算分公司版权所有 京ICP备 12022551号'
    return footer;
  }
}


