<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <title>欢迎使用360度测评系统</title>
    <link rel="shortcut icon" href="favicon.ico"> <link href="${basePath }/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="${basePath }/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath }/css/animate.css" rel="stylesheet">
    <link href="${basePath }/css/style.css?v=4.0.0" rel="stylesheet">
    <link href="${basePath }/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
</head>

<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
    <div id="wrapper">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <div class="nav-close"><i class="fa fa-times-circle"></i>
            </div>
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="nav-header">
                        <div class="dropdown profile-element text-center">
                            <span><img alt="image" class="img-circle" src="img/photo.jpg" width="65" height="65"/></span>
                            <a href="#" data-toggle="modal" data-target="#modal">
                                <span class="clear">
                                <span class="block m-t-xs">欢迎登录,&nbsp;<strong class="font-bold">${sessionScope.ee.zname }</strong></span>
                                 <span class="block m-t-xs">当前角色,&nbsp;<strong class="font-bold">${sessionScope.rName }</strong></span>
                                <!-- <span class="text-muted text-xs block"><b class="caret"></b></span> -->
                                </span>
                            </a>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        
         <!--Start 添加或修改模态窗口 -->
      <div class="modal inmodal" id="modal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">修改密码</h5>
                  </div>
                  	<!--Start 表单 -->
                <form class="form-horizontal m-t" id="pwdForm" action="${basePath}/system/employee/updatePWd">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="eid" name="employee.eid" value="${sessionScope.ee.eid}"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">新密码：</label>
					                   <div class="col-sm-8">
					                       <input id="pwd" name="employee.pwd"  minlength="6" type="password" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					                 <div class="form-group">
					                   <label class="col-sm-3 control-label">确认密码：</label>
					                   <div class="col-sm-8">
					                       <input id="cpwd" name="cpwd"  minlength="6" type="password" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					       </div>
                 	 </div>
	                   <div class="modal-footer">
	                  		 <div class="form-group">
			                   <div class="col-sm-4 col-sm-offset-7">
			                       <button class="btn " id="close" type="button" data-dismiss="modal">关闭</button>
			                       <button class="btn btn-primary"id="submit" type="submit">提交</button>
			                   </div>
			                 </div>
		                  </div>
                  </form>
                  <!-- End 表单 -->
              </div>
          </div>
      </div>
     <!--End 添加或修改模态窗口 -->
     
        <!--左侧导航结束-->
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row content-tabs">
                <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
                </button>
                <nav class="page-tabs J_menuTabs">
                    <div class="page-tabs-content">
                        <a href="javascript:;" class="active J_menuTab" data-id="index_v1.html">首页</a>
                    </div>
                </nav>
                <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
                </button>
                <div class="btn-group roll-nav roll-right">
                    <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>
                    </button>
                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
                        <li class="J_tabShowActive"><a>定位当前选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                        </li>
                        <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                        </li>
                    </ul>
                </div>
                <a href="${basePath }/out" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
            </div>
            <div class="row J_mainContent" id="content-main">
                <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="index_v1.html?v=4.0" frameborder="0" data-id="index_v1.html" seamless></iframe>
            </div>
            <div class="footer">
                <div class="pull-right">&copy; 2015-2016 长春担保
                </div>
            </div>
        </div>
        <!--右侧部分结束-->
        
    </div>

    <!-- 全局js -->
    <script src="${basePath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath }/js/bootstrap.min.js?v=3.3.5"></script>
    <script src="${basePath }/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="${basePath }/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <script src="${basePath }/js/plugins/layer/layer.min.js"></script>
		<!-- 自定义参数 tablejs -->
	<script src="${basePath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basePath }/js/plugins/validate/messages_zh.min.js"></script>
    <script src="${basePath }/js/demo/form-validate-demo.js"></script>
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <!-- 自定义js -->
    <script src="${basePath }/js/menu.js"></script>
    <script src="${basePath }/js/hplus.js?v=4.0.0"></script>
    <!-- 第三方插件 -->
    <script src="${basePath }/js/plugins/pace/pace.min.js"></script>
    <script type="text/javascript">
    var testMenu=[];
          	$(function(){
          		
          		 $("#pwdForm").validate({
 		   		    submitHandler: function() {
 			   		    $.ajax({
 			     			cache: false,
 			     			type: "POST",
 			     			url: "${basePath}/system/employee/updatePwd",	
 			     			data:  $("#pwdForm").serialize(),	
 			     			async: false,
 			     			success: function(data) {
 			     				if(data.message=='success'){
 			     					$("#close").click();
 			     					swal({title:"密码",text:"修改成功",timer:2000, type: "success"});
 			     				}else{
 			     					swal({title:"密码",text:data.message,timer:2000, type: "error"});
 			     					$("#pwd").val("");
 			     					$("#cpwd").val("");
 			     				}
 			     			},
 			     			error: function(request) {
 			     			}
 			    		});
 		   		    }
 		    	});
          		
          		$.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath }/system/authority/getMenu?a="+Math.random(),	
	     			data: {},	
	     			async: false,
	     			success: function(data) {
	     				testMenu = data;
	     				new AccordionMenu({menuArrs:testMenu});
	     			},
     			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
                    }
	    		});
          	});
    
          	$(function () {
          	    //计算元素集合的总宽度
          	    function calSumWidth(elements) {
          	        var width = 0;
          	        $(elements).each(function () {
          	            width += $(this).outerWidth(true);
          	        });
          	        return width;
          	    }
          	    //滚动到指定选项卡
          	    function scrollToTab(element) {
          	        var marginLeftVal = calSumWidth($(element).prevAll()), marginRightVal = calSumWidth($(element).nextAll());
          	        // 可视区域非tab宽度
          	        var tabOuterWidth = calSumWidth($(".content-tabs").children().not(".J_menuTabs"));
          	        //可视区域tab宽度
          	        var visibleWidth = $(".content-tabs").outerWidth(true) - tabOuterWidth;
          	        //实际滚动宽度
          	        var scrollVal = 0;
          	        if ($(".page-tabs-content").outerWidth() < visibleWidth) {
          	            scrollVal = 0;
          	        } else if (marginRightVal <= (visibleWidth - $(element).outerWidth(true) - $(element).next().outerWidth(true))) {
          	            if ((visibleWidth - $(element).next().outerWidth(true)) > marginRightVal) {
          	                scrollVal = marginLeftVal;
          	                var tabElement = element;
          	                while ((scrollVal - $(tabElement).outerWidth()) > ($(".page-tabs-content").outerWidth() - visibleWidth)) {
          	                    scrollVal -= $(tabElement).prev().outerWidth();
          	                    tabElement = $(tabElement).prev();
          	                }
          	            }
          	        } else if (marginLeftVal > (visibleWidth - $(element).outerWidth(true) - $(element).prev().outerWidth(true))) {
          	            scrollVal = marginLeftVal - $(element).prev().outerWidth(true);
          	        }
          	        $('.page-tabs-content').animate({
          	            marginLeft: 0 - scrollVal + 'px'
          	        }, "fast");
          	    }
          	    //查看左侧隐藏的选项卡
          	    function scrollTabLeft() {
          	        var marginLeftVal = Math.abs(parseInt($('.page-tabs-content').css('margin-left')));
          	        // 可视区域非tab宽度
          	        var tabOuterWidth = calSumWidth($(".content-tabs").children().not(".J_menuTabs"));
          	        //可视区域tab宽度
          	        var visibleWidth = $(".content-tabs").outerWidth(true) - tabOuterWidth;
          	        //实际滚动宽度
          	        var scrollVal = 0;
          	        if ($(".page-tabs-content").width() < visibleWidth) {
          	            return false;
          	        } else {
          	            var tabElement = $(".J_menuTab:first");
          	            var offsetVal = 0;
          	            while ((offsetVal + $(tabElement).outerWidth(true)) <= marginLeftVal) {//找到离当前tab最近的元素
          	                offsetVal += $(tabElement).outerWidth(true);
          	                tabElement = $(tabElement).next();
          	            }
          	            offsetVal = 0;
          	            if (calSumWidth($(tabElement).prevAll()) > visibleWidth) {
          	                while ((offsetVal + $(tabElement).outerWidth(true)) < (visibleWidth) && tabElement.length > 0) {
          	                    offsetVal += $(tabElement).outerWidth(true);
          	                    tabElement = $(tabElement).prev();
          	                }
          	                scrollVal = calSumWidth($(tabElement).prevAll());
          	            }
          	        }
          	        $('.page-tabs-content').animate({
          	            marginLeft: 0 - scrollVal + 'px'
          	        }, "fast");
          	    }
          	    //查看右侧隐藏的选项卡
          	    function scrollTabRight() {
          	        var marginLeftVal = Math.abs(parseInt($('.page-tabs-content').css('margin-left')));
          	        // 可视区域非tab宽度
          	        var tabOuterWidth = calSumWidth($(".content-tabs").children().not(".J_menuTabs"));
          	        //可视区域tab宽度
          	        var visibleWidth = $(".content-tabs").outerWidth(true) - tabOuterWidth;
          	        //实际滚动宽度
          	        var scrollVal = 0;
          	        if ($(".page-tabs-content").width() < visibleWidth) {
          	            return false;
          	        } else {
          	            var tabElement = $(".J_menuTab:first");
          	            var offsetVal = 0;
          	            while ((offsetVal + $(tabElement).outerWidth(true)) <= marginLeftVal) {//找到离当前tab最近的元素
          	                offsetVal += $(tabElement).outerWidth(true);
          	                tabElement = $(tabElement).next();
          	            }
          	            offsetVal = 0;
          	            while ((offsetVal + $(tabElement).outerWidth(true)) < (visibleWidth) && tabElement.length > 0) {
          	                offsetVal += $(tabElement).outerWidth(true);
          	                tabElement = $(tabElement).next();
          	            }
          	            scrollVal = calSumWidth($(tabElement).prevAll());
          	            if (scrollVal > 0) {
          	                $('.page-tabs-content').animate({
          	                    marginLeft: 0 - scrollVal + 'px'
          	                }, "fast");
          	            }
          	        }
          	    }

          	    //通过遍历给菜单项加上data-index属性
          	    $(".J_menuItem").each(function (index) {
          	        if (!$(this).attr('data-index')) {
          	            $(this).attr('data-index', index);
          	        }
          	    });

          	    function menuItem() {
          	        // 获取标识数据
          	        var dataUrl = $(this).attr('href'),
          	            dataIndex = $(this).data('index'),
          	            menuName = $.trim($(this).text()),
          	            flag = true;
          	        if (dataUrl == undefined || $.trim(dataUrl).length == 0)return false;
          	        // 选项卡菜单已存在
          	        $('.J_menuTab').each(function () {
          	            if ($(this).data('id') == dataUrl) {
          	                if (!$(this).hasClass('active')) {
          	                    $(this).addClass('active').siblings('.J_menuTab').removeClass('active');
          	                    scrollToTab(this);
          	                    // 显示tab对应的内容区
          	                    $('.J_mainContent .J_iframe').each(function () {
          	                        if ($(this).data('id') == dataUrl) {
          	                            $(this).show().siblings('.J_iframe').hide();
          	                            return false;
          	                        }
          	                    });
          	                }
          	                flag = false;
          	                return false;
          	            }
          	        });

          	        // 选项卡菜单不存在
          	        if (flag) {
          	            var str = '<a href="javascript:;" class="active J_menuTab" data-id="' + dataUrl + '">' + menuName + ' <i class="fa fa-times-circle"></i></a>';
          	            $('.J_menuTab').removeClass('active');

          	            // 添加选项卡对应的iframe
          	            var str1 = '<iframe class="J_iframe" name="iframe' + dataIndex + '" width="100%" height="100%" src="' + dataUrl + '?v=4.0" frameborder="0" data-id="' + dataUrl + '" seamless></iframe>';
          	            $('.J_mainContent').find('iframe.J_iframe').hide().parents('.J_mainContent').append(str1);

          	            //显示loading提示
          	            var loading = layer.load();

          	            $('.J_mainContent iframe:visible').load(function () {
          	                //iframe加载完成后隐藏loading提示
          	                layer.close(loading);
          	            });
          	            // 添加选项卡
          	            $('.J_menuTabs .page-tabs-content').append(str);
          	            scrollToTab($('.J_menuTab.active'));
          	        }
          	        return false;
          	    }

          	    $('.J_menuItem').on('click', menuItem);

          	    // 关闭选项卡菜单
          	    function closeTab() {
          	        var closeTabId = $(this).parents('.J_menuTab').data('id');
          	        var currentWidth = $(this).parents('.J_menuTab').width();

          	        // 当前元素处于活动状态
          	        if ($(this).parents('.J_menuTab').hasClass('active')) {

          	            // 当前元素后面有同辈元素，使后面的一个元素处于活动状态
          	            if ($(this).parents('.J_menuTab').next('.J_menuTab').size()) {

          	                var activeId = $(this).parents('.J_menuTab').next('.J_menuTab:eq(0)').data('id');
          	                $(this).parents('.J_menuTab').next('.J_menuTab:eq(0)').addClass('active');

          	                $('.J_mainContent .J_iframe').each(function () {
          	                    if ($(this).data('id') == activeId) {
          	                        $(this).show().siblings('.J_iframe').hide();
          	                        return false;
          	                    }
          	                });

          	                var marginLeftVal = parseInt($('.page-tabs-content').css('margin-left'));
          	                if (marginLeftVal < 0) {
          	                    $('.page-tabs-content').animate({
          	                        marginLeft: (marginLeftVal + currentWidth) + 'px'
          	                    }, "fast");
          	                }

          	                //  移除当前选项卡
          	                $(this).parents('.J_menuTab').remove();

          	                // 移除tab对应的内容区
          	                $('.J_mainContent .J_iframe').each(function () {
          	                    if ($(this).data('id') == closeTabId) {
          	                        $(this).remove();
          	                        return false;
          	                    }
          	                });
          	            }

          	            // 当前元素后面没有同辈元素，使当前元素的上一个元素处于活动状态
          	            if ($(this).parents('.J_menuTab').prev('.J_menuTab').size()) {
          	                var activeId = $(this).parents('.J_menuTab').prev('.J_menuTab:last').data('id');
          	                $(this).parents('.J_menuTab').prev('.J_menuTab:last').addClass('active');
          	                $('.J_mainContent .J_iframe').each(function () {
          	                    if ($(this).data('id') == activeId) {
          	                        $(this).show().siblings('.J_iframe').hide();
          	                        return false;
          	                    }
          	                });

          	                //  移除当前选项卡
          	                $(this).parents('.J_menuTab').remove();

          	                // 移除tab对应的内容区
          	                $('.J_mainContent .J_iframe').each(function () {
          	                    if ($(this).data('id') == closeTabId) {
          	                        $(this).remove();
          	                        return false;
          	                    }
          	                });
          	            }
          	        }
          	        // 当前元素不处于活动状态
          	        else {
          	            //  移除当前选项卡
          	            $(this).parents('.J_menuTab').remove();

          	            // 移除相应tab对应的内容区
          	            $('.J_mainContent .J_iframe').each(function () {
          	                if ($(this).data('id') == closeTabId) {
          	                    $(this).remove();
          	                    return false;
          	                }
          	            });
          	            scrollToTab($('.J_menuTab.active'));
          	        }
          	        return false;
          	    }

          	    $('.J_menuTabs').on('click', '.J_menuTab i', closeTab);

          	    //关闭其他选项卡
          	    function closeOtherTabs(){
          	        $('.page-tabs-content').children("[data-id]").not(":first").not(".active").each(function () {
          	            $('.J_iframe[data-id="' + $(this).data('id') + '"]').remove();
          	            $(this).remove();
          	        });
          	        $('.page-tabs-content').css("margin-left", "0");
          	    }
          	    $('.J_tabCloseOther').on('click', closeOtherTabs);

          	    //滚动到已激活的选项卡
          	    function showActiveTab(){
          	        scrollToTab($('.J_menuTab.active'));
          	    }
          	    $('.J_tabShowActive').on('click', showActiveTab);


          	    // 点击选项卡菜单
          	    function activeTab() {
          	        if (!$(this).hasClass('active')) {
          	            var currentId = $(this).data('id');
          	            // 显示tab对应的内容区
          	            $('.J_mainContent .J_iframe').each(function () {
          	                if ($(this).data('id') == currentId) {
          	                    $(this).show().siblings('.J_iframe').hide();
          	                    return false;
          	                }
          	            });
          	            $(this).addClass('active').siblings('.J_menuTab').removeClass('active');
          	            scrollToTab(this);
          	        }
          	    }

          	    $('.J_menuTabs').on('click', '.J_menuTab', activeTab);

          	    //刷新iframe
          	    function refreshTab() {
          	        var target = $('.J_iframe[data-id="' + $(this).data('id') + '"]');
          	        var url = target.attr('src');
          	        //显示loading提示
          	        var loading = layer.load();
          	        target.attr('src', url).load(function () {
          	            //关闭loading提示
          	            layer.close(loading);
          	        });
          	    }

          	    $('.J_menuTabs').on('dblclick', '.J_menuTab', refreshTab);

          	    // 左移按扭
          	    $('.J_tabLeft').on('click', scrollTabLeft);

          	    // 右移按扭
          	    $('.J_tabRight').on('click', scrollTabRight);

          	    // 关闭全部
          	    $('.J_tabCloseAll').on('click', function () {
          	        $('.page-tabs-content').children("[data-id]").not(":first").each(function () {
          	            $('.J_iframe[data-id="' + $(this).data('id') + '"]').remove();
          	            $(this).remove();
          	        });
          	        $('.page-tabs-content').children("[data-id]:first").each(function () {
          	            $('.J_iframe[data-id="' + $(this).data('id') + '"]').show();
          	            $(this).addClass("active");
          	        });
          	        $('.page-tabs-content').css("margin-left", "0");
          	    });

          	});
    </script>
</body>

</html>