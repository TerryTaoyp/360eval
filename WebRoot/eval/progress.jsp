<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>部门类别管理</title>
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
	    <div class="row">
	            <div class="col-sm-12">
	                <div class="ibox">
	                    <div class="ibox-title text-center">
	                        <h2>测评进度管理</h2>
	                    </div>
	                    <div class="ibox-content">
								<div class="btn-group hidden-xs" id="tableToolbar" role="group">
						        	<span style="font-size:18px;">当前参评统计:
						        	  实际参评<span style="color:green">${evalTotal }</span>人,应参评<span style="color:blue">${eeTotal }</span>人,还有
						        	 <span style="color:red">${eeTotal-evalTotal }</span>人未登录进行参评!&nbsp;&nbsp;当前数据展示:(实参/应参)
						        	</span>
	                              </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/eval/progress/getProgressList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="eid" class="col-sm-1">编号</th>
	                                       <th data-field="dname" class="col-sm-2">部门</th>
	                                       <th data-field="rname" class="col-sm-1">角色</th>
	                                       <th data-field="zname" class="col-sm-1">姓名</th>
	                                       <th data-formatter="pstatusFormatter" class="col-sm-1">参评状态</th>
	                                       <th data-field="siseval" data-formatter="sisevalFormatter" class="col-sm-1">满意度测评</th>
	                                       <th data-field="dnum" class="col-sm-1">部门测评</th>
	                                       <th data-field="ednum" class="col-sm-1">部门经理测评</th>
	                                       <th data-field="eenum" class="col-sm-1">普通员工测评</th>
	                                       <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-2">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script src="${basePath }/js/plugins/layer/laydate/laydate.js"></script>
    <script type="text/javascript">
    
	var $table = $("#table");
    
  	//表格其他属性  行变色data-row-style="rowStyle" 高度data-height="485"
  	//自定义数据参数
  	var pa;
    function queryParams(params) {
    	pa = params;
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/progress/getProgressList",query: {offset: pa.offset}});
    }
    window.operateEvents = {
	    	      'click .produce': function (e, value, row) {
	    				swal({
	    	                title: "员工参评数据",
	    	                text: "确定生成员工参评数据",
	    	                type: "warning",
	    	                showCancelButton: true,
	    	                confirmButtonColor: "#DD6B55",
	    	                confirmButtonText: "确定",
	    	                cancelButtonText: "取消",
	    	                closeOnConfirm: false
	    	            }, function () {
	    	            	 $.ajax({
	     		     			cache: false,
	     		     			type: "POST",	
	     		     			url: "${basePath}/eval/progress/addOrUpdateProgress",	
	     		     			data: {eid: row.eid,did: row.did,rname: row.rname},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"员工参评数据",text:"生成成功",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	      }
        };

	    function sisevalFormatter(value, row, index) {
	   	 var str = "";
	   	 if(row.siseval==1){
	   		 str = "已测评";
	   	 }else if(row.siseval==0){
	   		str = "未测评";
	   	 }else{
	   		str = '-';
	   	 }
	       return [ str ].join('');
	   }
	    function pstatusFormatter(value, row, index) {
	    	 var str = "";
	    	 if(row.ednum==null||row.dnum==null||row.eenum==null||row.siseval==null){
        		 str = "<span style='color:red;'>未参评</span>";
        	 }else{
        		 str = "<span style='color:green;'>已参评</span>";
        	 }
            return [ str ].join('');
		   }
        function operateFormatter(value, row, index) {
        	var opStr = 'glyphicon-plus"></i>&nbsp;&nbsp;生成参评数据';
        	if(!(row.ednum==null||row.dnum==null||row.eenum==null||row.siseval==null)){
        		opStr = 'glyphicon-edit"></i>&nbsp;&nbsp;更新参评数据';
        	}
            return [
                '<div >',
                '<button type="button" class="btn produce btn-primary btn-sm btn-outline">',
                '<i class="glyphicon '+opStr+'</button>',
                '</div>'
            ].join('');
        }
    
    $(function(){
    	
    });
    
    </script>
</body>
</html>