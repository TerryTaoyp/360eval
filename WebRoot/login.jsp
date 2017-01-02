<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
	 <title>欢迎使用360度测评系统</title>
	<link rel="icon" href="favicon.ico" type="image/x-icon" />
	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
    <link href="${basePath }/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="${basePath }/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath }/css/animate.css" rel="stylesheet">
    <link href="${basePath }/css/style.css?v=4.0.0" rel="stylesheet">
    <link href="${basePath }/css/login.css" rel="stylesheet">
    <!--[if lt IE 8]>
    	<script>window.location.href='${basePath }/ie.html';</script>
    <![endif]-->
    <script>
        if (window.top !== window.self) {
            window.top.location = window.location;
        }
    </script>

</head>

<body class="signin">
  <div style="margin-top:50px;">
  	
  </div>
    <div class="signinpanel">
        <div class="row">
            <div class="col-sm-7">
                <div class="signin-info">
                    <div class=" m-b">
				  		<img alt="" src="${basePath }/img/logo.png" width="380" height="290"  >
                    </div>
                     
                </div>
            </div>
            <div class="col-sm-5">
                       
                <form method="post" action="${basePath}/check"  method="post">
                 	<h4 >欢迎使用长春担保年度考评系统</h4>
                    <h6 class="no-margins">用户登录:</h6>
                    <p class="m-t-md"><span style="color:red">${error }</span></p>
                    <input type="text" name="employee.ename" class="form-control uname" placeholder="登录名" />
                    <input type="password" name="employee.pwd" class="form-control pword m-b" placeholder="密码" />
                    <!-- <a href="#">忘记密码？</a>  -->
                     <strong>还没有账号？ <a href="${basePath}/register">立即注册&raquo;</a></strong>
                    <p>&nbsp;</p>
                    <button class="btn btn-success btn-block">登录</button>
                </form>
            </div>
        </div>
        <div class="signup-footer">
            <div class="pull-right">
                &copy; 2015 All Rights Reserved. 长春担保 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </div>
        </div>
    </div>
    
       <!-- 全局js -->
    <script src="${basePath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath }/js/bootstrap.min.js?v=3.3.5"></script>
    <!-- 自定义js -->
    <script src="${basePath }/js/content.js?v=1.0.0"></script>
    <!-- Bootstrap table -->
	<script src="${basePath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basePath }/js/plugins/validate/messages_zh.min.js"></script>
    <script src="${basePath }/js/demo/form-validate-demo.js"></script>
</body>

</html>