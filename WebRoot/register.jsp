<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>欢迎使用360度测评系统</title>

    <link rel="shortcut icon" href="favicon.ico"> <link href="${basePath }/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="${basePath }/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath }/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <link href="${basePath }/css/animate.css" rel="stylesheet">
    <link href="${basePath }/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
    <link href="${basePath }/css/style.css?v=4.0.0" rel="stylesheet">
    <link href="${basePath }/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
    <link href="${basePath }/css/plugins/iCheck/custom.css" rel="stylesheet">
    <base target="_blank">

</head>

<body class="gray-bg">
<div class="middle-box text-center animated fadeInDown">
		<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h3>员工注册</h3>
                    </div>
                    <div class="ibox-content ">
                        <form class="form-horizontal m-t" action="${basePath }/system/employee/newEm" id="rigesterForm" method="post">
                        	<p>登录信息</p>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">登录名：</label>
                                <div class="col-sm-5">
                                    <input id="ename" name="employee.ename"  type="text" minlength="2"  class="form-control" required="" aria-required="true">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">密码：</label>
                                <div class="col-sm-5">
                                    <input id="password" name="employee.pwd" type="password"  minlength="6"  class="form-control" required="" aria-required="true" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">确认密码：</label>
                                <div class="col-sm-5">
                                    <input id="confirm_password" name="confirm_password" type="password" minlength="6"  class="form-control" required="" aria-required="true" >
                                </div>
                            </div>
                            <p>基本信息</p>
                           <div class="form-group">
                                <label class="col-sm-4 control-label">姓名：</label>
                                <div class="col-sm-5">
                                    <input id="zname" name="employee.zname" type="text" minlength="2"  class="form-control" required="" aria-required="true">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">性别：</label>
                                <div class="col-sm-5">
                                 <label class="i-checks"><input type="radio" name="employee.sex" value="0" checked="checked">男</label>
                                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label class="i-checks"><input type="radio" name="employee.sex" value="1">女</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">身份证：</label>
                                <div class="col-sm-5">
                                    <input id="card" name="employee.card" type="text" minlength="2"  class="form-control" required="" aria-required="true">
                                </div>
                            </div>
                             <div class="form-group">
                                <label class="col-sm-4 control-label">部门：</label>
                                <div class="col-sm-5">
                                      <select id="did" name="employee.did" class="form-control m-b"  required="" aria-required="true" >
				                       		 	<option value="">请选择部门</option>
				                       		  <c:forEach items="${departmentList}" var="dm">
				                       		  	<option value="${dm.did }">${dm.dname }</option>
				                       		  </c:forEach>
		                              </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-5 col-sm-offset-4">
                                	<button class="btn btn-default" type="reset">重置</button>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <button class="btn btn-primary" type="submit">提交</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
 </div>
	<!--End 当前容器开始 -->
   <!-- 全局js -->
    <script src="${basePath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath }/js/bootstrap.min.js?v=3.3.5"></script>
    <!-- 自定义js -->
    <script src="${basePath }/js/content.js?v=1.0.0"></script>
	<!-- 自定义参数 tablejs -->
	 <script src="${basePath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basePath }/js/plugins/validate/messages_zh.min.js"></script>
    <script src="${basePath }/js/demo/form-validate-demo.js"></script>
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <!-- iCheck -->
    <script src="${basePath }/js/plugins/iCheck/icheck.min.js"></script>
    <script type="text/javascript">
		$(function(){
			$("#rigesterForm").validate({
	   		    submitHandler: function() {
		   		    $.ajax({
		     			cache: false,
		     			type: "POST",
		     			url: '${basePath }/system/employee/newEm',	
		     			data: $("#rigesterForm").serialize(),	
		     			async: false,
		     			success: function(data) {
		     				//alert(JSON.stringify(data));
		     				if(data.message=='success'){
		     					swal({title:"用户注册",text:"恭喜你注册成功,请等待管理员审核!",timer:2000, type: "success"});
		     				}else{
		     					swal({title:"用户注册",text:data.message,timer:2000, type: "error"});
		     					$("#password").val("");
		     					$("#confirm_password").val("");
		     					$("#card").val("");
		     					$("#enum").val("");
		     				}
		     			},
		     			error: function(request) {
		     			}
		    		});
	   		    }
	    	});
			
		});
    
		 $(document).ready(function () {
	            $('.i-checks').iCheck({
	                checkboxClass: 'icheckbox_square-green',
	                radioClass: 'iradio_square-green',
	            });
	        });
    </script>
</body>
</html>