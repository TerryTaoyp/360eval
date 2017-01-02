<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>部门类型管理</title>
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">

    <link rel="shortcut icon" href="favicon.ico"> <link href="${basePath }/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="${basePath }/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${basePath }/css/plugins/bootstrap-table/bootstrap-table.min.css" rel="stylesheet">
    <link href="${basePath }/css/animate.css" rel="stylesheet">
    <link href="${basePath }/css/plugins/sweetalert/sweetalert.css" rel="stylesheet">
    <link href="${basePath }/css/style.css?v=4.0.0" rel="stylesheet">
    <link href="${basePath }/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
    <base target="_blank">

</head>

<body class="gray-bg">
	<!-- Start 当前容器开始 -->
    <div class="wrapper wrapper-content animated fadeInRight">
	    <!-- Start 当前表格开始 -->
	    <div class="row">
	            <div class="col-sm-12">
	                <div class="ibox">
	                    <div class="ibox-title text-center">
	                        <h2>普通员工测评结果</h2>
	                    </div>
	                    <div class="ibox-content">
							<div class="btn-group hidden-xs" id="tableToolbar" role="group">
								<button type="button" class="btn btn-outline btn-primary" onclick="javascript:history.go(-1);" >
	                            	<i class="fa fa-reply"></i>&nbsp;返回
	                          	</button>
	                          	<c:if test="${fn:contains(sessionScope.rName,'管理员')==true
	                          		||fn:contains(sessionScope.rName,'董事长')==true
	                          		||( fn:contains(sessionScope.rName,'副总经理')==false&&fn:contains(sessionScope.rName,'总经理')==true ) }">
	                          	<a href="${basePath}/result/employeeResult/exportEEResult?sid=${sid}&epType=1" class="btn btn-outline btn-primary"><i class="glyphicon glyphicon-export"></i>&nbsp;导出加权汇总</a>
	                          	<a href="${basePath}/result/employeeResult/exportEEResult?sid=${sid}&epType=0" class="btn btn-outline btn-primary"><i class="glyphicon glyphicon-export"></i>&nbsp;导出原始汇总</a>
	                          	</c:if>
	                         </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/result/employeeResult/getEeList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="eid" class="col-sm-1">编号</th>
	                                       <th data-field="dname" class="col-sm-3">部门</th>
	                                       <th data-field="zname" class="col-sm-3">姓名</th>
	                                        <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-5">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
   		
    </div>
	<!--End 当前容器开始 -->
   <!-- 全局js -->
    <script src="${basePath }/js/jquery.min.js?v=2.1.4"></script>
    <script src="${basePath }/js/bootstrap.min.js?v=3.3.5"></script>
    <!-- 自定义js -->
    <script src="${basePath }/js/content.js?v=1.0.0"></script>
    <!-- Bootstrap table -->
    <script src="${basePath }/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
    <script src="${basePath }/js/plugins/bootstrap-table/bootstrap-table-mobile.min.js"></script>
    <script src="${basePath }/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>
	<!-- 自定义参数 tablejs -->
	<script src="${basePath }/js/common/defaultServerTable.js"></script> 
	 <script src="${basePath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basePath }/js/plugins/validate/messages_zh.min.js"></script>
    <script src="${basePath }/js/demo/form-validate-demo.js"></script>
    <script src="${basePath }/js/plugins/layer/layer.min.js"></script>
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
	var $table = $("#table");
    
    function queryParams(params) {
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/result/employeeResult/getEeList"});
    }
    window.operateEvents = {
    	         'click .select': function (e, value, row) {
	    	        	 layer.open({
	    	                 type: 2,
	    	                 title: ['&nbsp;&nbsp;'+row.dname+'—'+row.zname+'(普通员工)测评结果', 'text-align:center;margin:0 auto;font-size:24px;'],
	    	                 shadeClose: false,
	    	                 shade: [0.3, '#393D49'],
	    	                 fix: true,
	    	                 //maxmin: true, //开启最大化最小化按钮
	    	                 area: ['1180px', '630px'],
	    	                 //closeBtn: 2,
	    	                 content: '${basePath}/result/employeeResult/getEeResult?eid='+row.eid+"&sid="+${sid}
	    	             });
    	        }
        };

        function operateFormatter(value, row, index) {
            return [
                '<div >',
                '<button type="button" class="btn select btn-primary btn-sm btn-outline ">',
                '<i class="glyphicon  glyphicon-search"></i>&nbsp;&nbsp;查看测评结果</button>',
                '<a  class="btn export btn-primary btn-sm btn-outline" href="${basePath}/result/employeeResult/exportEEResult?sid=${sid}&epType=0&eid='+row.eid+'" >',
                '<i class="glyphicon glyphicon-export"></i>&nbsp;导出测评结果</a>',
                '</div>'
            ].join('');
        }
    
    </script>
</body>
</html>