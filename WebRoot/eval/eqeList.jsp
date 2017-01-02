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
    <link href="${basePath }/css/plugins/iCheck/custom.css" rel="stylesheet">
    <base target="_blank">
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                     <div class="ibox-title text-center text-center">
	                        <h2>${sname }——普通普通员工测评</h2>
	                    </div>
                    <div class="ibox-content">

                        <div class="row">
                            <div class="col-sm-2" id="left">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                       		 公司部门
                                    </div>
                                    <div class="panel-body">
	                                      <div >
												<ul id="departmentTree" class="ztree"></ul>
										  </div>
                                    </div>

                                </div>
                            </div>
                            <div class="col-sm-10" id="right">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                       	人员列表
                                    </div>
                                    <div class="panel-body">
                                       	
										<div class="btn-group hidden-xs" id="tableToolbar" role="group">
				                                  <button type="button" class="btn  btn-primary" disabled="true" id="batchRemove">
									            	<i class="glyphicon glyphicon-ok"> </i>&nbsp;&nbsp;批量提交
									        	 </button>
				                              </div>
				                              <table 
				                              	id="table" 
				                              	data-toggle="table" 
				                              	data-url="${basePath}/eval/employeeQuestionBasic/getEqeList" 
				                              	data-query-params="queryParams"
				                              >
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="eid" class="col-sm-1">编号</th>
				                                    <th data-field="zname" data-formatter="znameFormatter" class="col-sm-2">名称</th>
				                                    <th data-field="dname"  class="col-sm-2">部门</th>
				                                    <th data-field="ertotal" data-formatter="ertotalFormatter" class="col-sm-1">总分</th>
				                                    <th data-field="erissubmit" data-formatter="erissubmitFormatter" class="col-sm-2">状态</th>
				                                    <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-3">操作</th>
									            </tr>
								            </thead>
								        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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
    <script src="${basePath }/js/plugins/layer/layer.min.js"></script>
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script src="${basePath }/js/plugins/iCheck/icheck.min.js"></script>
    <script type="text/javascript">
    
    var $table = $("#table");
	var $remove = $("#batchRemove");
    var did = 0;
    var dtid = 0;
    var setting = {
			data: {
			},
			callback: {
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[];
		function getZNodes(){
			 $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath }/system/department/getDepartmentTree",	
	     			data: {dataType: '1'},	
	     			async: false,
	     			success: function(data) {
	     				zNodes = data;
	     				$.fn.zTree.init($("#departmentTree"), setting, zNodes);
	     			},
     			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
                    }
	    		});
		}
		
		function beforeClick(treeId, treeNode, clickFlag) {
			return (treeNode.click != false);
		}
		function onClick(event, treeId, treeNode, clickFlag) {
			did = typeof(treeNode.id)=="undefined"?0:treeNode.id; //给参数赋值,然后刷新部门列表
			dtid = typeof(treeNode.pId)=="undefined"?0:treeNode.pId;
			refresh();
		}		

		$(document).ready(function(){
			getZNodes();
		});
	    
		//自定义数据参数
	    function queryParams(params) {
	    	params.did = did; //自定义参数
	    	params.dtid = dtid; //自定义参数
	    	return params;
	    }
	    function refresh(){
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/employeeQuestionBasic/getEqeList"});
	    }
	    window.operateEvents = {
		    		 'click .stest': function (e, value, row) {
		    	             layer.open({
		    	                 type: 2,
		    	                 title: ['&nbsp;&nbsp;'+row.zname+'普通员工测评', 'text-align:center;margin:0 auto;font-size:24px;'],
		    	                 shadeClose: false,
		    	                 shade: [0.3, '#393D49'],
		    	                 fix: true,
		    	                 //maxmin: true, //开启最大化最小化按钮
		    	                  area: ['85%', '85%'],
		    	                 //closeBtn: 2,
		    	                 content: '${basePath}/eval/employeeQuestionBasic/eqeTest?dtid='+row.dtid+"&rid="+row.rid+"&eid="+row.eid
		    	             });
		    	      },
	    	         'click .submit': function (e, value, row) {
	    	        	swal({
	    	                title: "确认提交当前普通员工测评",
	    	                text: "提交后结果将无法更改，请谨慎操作！",
	    	                type: "warning",
	    	                showCancelButton: true,
	    	                confirmButtonColor: "#DD6B55",
	    	                confirmButtonText: "提交",
	    	                cancelButtonText: "取消",
	    	                closeOnConfirm: false
	    	            }, function () {
	    	            	 $.ajax({
	     		     			cache: false,
	     		     			type: "POST",
	     		     			url: "${basePath}/result/employeeResult/submitEmployeeResult",	
	     		     			data: {erid: row.erid},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"普通员工测评",text:"提交成功!",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	        }
	        };
		    function erissubmitFormatter(value, row, index) {
			   	 var str = "";
			   	 if(row.ertotal==0.0){
			   		 str = "未测评";
			   	 }else{
			   		 if(row.erissubmit==0){
			   			 str = "未提交";
			   		 }else{
			   			 str = "已提交"; 
			   		 }
			   	 }
			     return [ str ].join('');
			 }
		    function ertotalFormatter(value, row, index) {
			   	 var str = row.ertotal.toFixed(2);
			     return [ str ].join('');
			 }
		    function znameFormatter(value, row, index) {
			   	 var str = row.zname+"普通员工测评";
			     return [ str ].join('');
			 }
	        function operateFormatter(value, row, index) {
	        	var issubmit ='';//是否可以提交
	        	var eval = '开始测评';
	        	if(row.erissubmit==1){
	        		issubmit = '" disabled="disabled"'; //已经提交不能再次提交
	        	}else{
	        		if(row.ertotal==0.0)
	        			issubmit = '" disabled="disabled"'; //未测评不能提交
	        		else
	        			issubmit = 'btn-outline"';//已测评未提交可以提交
	        	}
	        	var isfinish ='';//是否可以测评
	        	if(row.erissubmit==1){
	        		isfinish = '" disabled="disabled"'; //已经提交不能再次测评
	        	}else{
	        		isfinish = 'btn-outline"';//未提交可以多次测评
	        		if(row.ertotal==0.0){
	        			eval = '开始测评';
	        		}else{
	        			eval ='重新测评';
	        		}
	        	}
	            return [
	                '<div >',
	                '<button type="button" class="btn stest btn-primary btn-sm '+isfinish,
	                '><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+eval+'</button>',
	                '<button type="button" class="btn submit btn-primary btn-sm '+issubmit+'>',
	                '<i class="glyphicon glyphicon-ok"></i>&nbsp;&nbsp;提交</button>',
	                '</div>'
	            ].join('');
	        }
	    
	    $(function(){
	    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
	             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
	         })
	    	 $remove.click(function () {
	             var erids = $.map($table.bootstrapTable('getSelections'), function (row) {
	            	 if(row.ertotal>0.0){
	            		return row.erid; 
	            	 }
	             });
	             swal({
		                title: "批量提交普通员工测评",
		                text: "提交后结果将无法更改，请谨慎操作！",
		                type: "warning",
		                showCancelButton: true,
		                confirmButtonColor: "#DD6B55",
		                confirmButtonText: "提交",
		                cancelButtonText: "取消",
		                closeOnConfirm: false
		            }, function () {
		            	 $.ajax({
			     			cache: false,
			     			type: "POST",
			     			url: "${basePath}/result/employeeResult/batchSubmitEmployeeResult",	
			     			data: {erids: erids.toString()},	
			     			async: false,
			     			success: function(data) {
			     				swal({title:"普通员工测评",text:"批量提交成功!",timer:2000, type: "success"});
			     				refresh();
			     			},
			     			error: function(request) {
			     			}
			    		});
		            });
	             $remove.prop('disabled', true);
	         });
	    });
	    
    </script>
</body>
</html>