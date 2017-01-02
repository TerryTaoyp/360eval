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
    <div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title text-center">
	                        <h2>${sname }——部门测评</h2>
	                    </div>
                    <div class="ibox-content">

                        <div class="row">
                            <div class="col-sm-2">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                       		 部门类型
                                    </div>
                                    <div class="panel-body">
	                                      <div >
												<ul id="treeDemo" class="ztree"></ul>
										  </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-10">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                       	部门测评列表
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
		                              	data-url="${basePath}/eval/departmentQuestion/getDqList" 
		                              	data-query-params="queryParams">
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="did" class="col-sm-1">编号</th>
				                                       <th data-field="dname" data-formatter="dnameFormatter" class="col-sm-3">名称</th>
				                                       <th data-field="drtotal" data-formatter="drtotalFormatter" class="col-sm-2">总分</th>
				                                       <th data-field="drissubmit" data-formatter="drissubmitFormatter" class="col-sm-2">状态</th>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script src="${basePath }/js/plugins/layer/layer.min.js"></script>
    <script type="text/javascript">
    
    var $table = $("#table");
	var $remove = $("#batchRemove");
    var dtid = 0;
    var setting = {
			data: {
				simpleData: {
					enable: true
				}
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
	     			url: "${basePath }/system/departmentType/getDepartmentTypeTree",	
	     			data: {dataType : '1'},	
	     			async: false,
	     			success: function(data) {
	     				zNodes = data;
	     				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	     			},
     			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
                    }
	    		});
		}
		function beforeClick(treeId, treeNode, clickFlag) {
			return (treeNode.click != false);
		}
		function onClick(event, treeId, treeNode, clickFlag) {
			dtid = treeNode.id; //给参数赋值,然后刷新部门测评列表
			refresh();
		}		

		$(document).ready(function(){
			getZNodes();
		});
		
	  	//自定义数据参数
	    function queryParams(params) {
	    	params.dtid = dtid; //自定义参数
	    	return params;
	    }
	    function refresh(){
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/departmentQuestion/getDqList"});
	    }
	    window.operateEvents = {
	    		 'click .stest': function (e, value, row) {
	    	             layer.open({
	    	                 type: 2,
	    	                 title: ['&nbsp;&nbsp;'+row.dname+'部门测评', 'text-align:center;margin:0 auto;font-size:24px;'],
	    	                 shadeClose: false,
	    	                 shade: [0.3, '#393D49'],
	    	                 fix: true,
	    	                 //maxmin: true, //开启最大化最小化按钮
	    	                 area: ['85%', '85%'],
	    	                 //closeBtn: 2,
	    	                 content: '${basePath}/eval/departmentQuestion/dqTest?dtid='+row.dtid+"&did="+row.did
	    	                 //content: 'satisfyTest.jsp'
	    	             });
	    	      },
   	         'click .submit': function (e, value, row) {
   	        	swal({
   	                title: "确认提交当前部门测评",
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
    		     			url: "${basePath }/result/departmentResult/submitDepartmentResult",	
    		     			data: {drid: row.drid},	
    		     			async: false,
    		     			success: function(data) {
    		     				swal({title:"部门测评",text:"提交成功!",timer:2000, type: "success"});
    		     				refresh();
    		     			},
    		     			error: function(request) {
    		     			}
    		    		});
   	            });
   	        }
       };
	    function drissubmitFormatter(value, row, index) {
		   	 var str = "";
		   	 if(row.drtotal==0.0){
		   		 str = "未测评";
		   	 }else{
		   		 if(row.drissubmit==0){
		   			 str = "未提交";
		   		 }else{
		   			 str = "已提交"; 
		   		 }
		   	 }
		     return [ str ].join('');
		 }
	    function dnameFormatter(value, row, index) {
		   	 var str = row.dname+'部门测评';
		     return [ str ].join('');
		 }
	    function drtotalFormatter(value, row, index) {
		   	 var str = row.drtotal.toFixed(2);
		     return [ str ].join('');
		 }
       function operateFormatter(value, row, index) {
       	var issubmit ='';//是否可以提交
       	var eval = '开始测评';
       	if(row.drissubmit==1){
       		issubmit = '" disabled="disabled"'; //已经提交不能再次提交
       	}else{
       		if(row.drtotal==0.0)
       			issubmit = '" disabled="disabled"'; //未测评不能提交
       		else
       			issubmit = 'btn-outline"';//已测评未提交可以提交
       	}
       	var isfinish ='';//是否可以测评
       	if(row.drissubmit==1){
       		isfinish = '" disabled="disabled"'; //已经提交不能再次测评
       	}else{
       		isfinish = 'btn-outline"';//未提交可以多次测评
       		if(row.drtotal==0.0){
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
        });
   	 $remove.click(function () {
            var drids = $.map($table.bootstrapTable('getSelections'), function (row) {
           	 if(row.drtotal>0.0){
           		return row.drid; 
           	 }
            });
            swal({
	                title: "批量提交部门测评",
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
		     			url: "${basePath }/result/departmentResult/batchSubmitDepartmentResult",	
		     			data: {drids: drids.toString()},	
		     			async: false,
		     			success: function(data) {
		     				swal({title:"部门测评",text:"批量提交成功!",timer:2000, type: "success"});
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