<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	                        <h2>测评结果生成</h2>
	                    </div>
	                    <div class="ibox-content">
								 <div class="btn-group hidden-xs" id="tableToolbar" role="group">
	                              </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath }/result/resultType/getProductList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                   <th data-field="id" class="col-sm-1">编号</th>
	                                       <th data-field="sname" class="col-sm-3">计划</th>
	                                       <th data-field="tname" class="col-sm-3">类型</th>
	                                       <th data-field="isProducted" data-formatter="isProductedFormatter" class="col-sm-2">状态</th>
	                                       <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-3">操作</th>
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
     <!-- ztree3.5 -->
    <script src="${basePath }/js/jquery.ztree.all-3.5.js"></script>
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
    <script type="text/javascript">
    
	//自定义数据参数
    function queryParams(params) {
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath }/result/resultType/getProductList"});
    }
    function getRandom(n){
        return Math.floor(Math.random()*n+1);
    }
    window.operateEvents = {
				  'click .product': function (e, value, row) {
					  swal({
	    	                title: "测评结果",
	    	                text: "确定生成当前测评结果",
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
	       		     			url: "${basePath }/result/resultType/product",	
	       		     			data: {id: row.id,isProducted: row.isProducted},	
	       		     			async: false,
	       		     			success: function(data) {
	       		     				swal({title:"测评结果",text:"生成成功",timer:2000, type: "success"});
	       		     				refresh();
	       		     			},
	       		     			error: function(request) {
	       		     			}
	       		    		});
	    	            });
				  }
        };
		
    	function isProductedFormatter(value, row, index){
    		var isProducted = row.isProducted;
    		var str = '';
    		if(isProducted=='1'){
    			str = "<span style='color:blue;'>已生成</span>";
    		}else{
    			str = "<span style='color:red;'>未生成</span>";
    		}
    		return [str].join('');
    	}
        function operateFormatter(value, row, index) {
        	var isProducted = row.isProducted;
    		var str = '';
    		if(isProducted=='1'){
    			str = "重新生成";
    		}else{
    			str = "生成结果";
    		}
            return [
                '<div >',
                '<button type="button" class="btn product btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#authorityModal"><i class="glyphicon ',  
                'glyphicon-edit"></i>&nbsp;&nbsp;'+str+'</button>',
                '</div>'
            ].join('');
        }
     
    
    </script>
</body>
</html>