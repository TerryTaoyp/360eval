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
                        <h2>员工测评要素管理</h2>
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
                                       	员工测评要素列表
                                    </div>
                                    <div class="panel-body">
                                       	<div class="btn-group hidden-xs" id="tableToolbar" role="group">
				                                  <button type="button" id="add" class="btn btn-outline btn-primary" data-toggle="modal" data-target="#modal">
				                            		 	<i class="glyphicon glyphicon-plus"></i>添加
				                          		</button>
				                                  <button type="button" class="btn  btn-primary" disabled="true" id="batchRemove">
									            <i class="glyphicon glyphicon-remove"></i>批量删除
									        </button>
				                              </div>
				                              <table 
				                              	id="table" 
				                              	data-toggle="table" 
				                              	data-url="${basePath}/eval/employeeQuestionBasic/getEmployeeQuestionBasicList" 
				                              	data-query-params="queryParams"
				                              >
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="eqbid" class="col-sm-1">编号</th>
			                                        <th data-field="dtname" data-formatter="dtnameFormatter" class="col-sm-1">部门类型</th>
			                                        <th data-field="eqbbasic" class="col-sm-2">测评要素</th>
			                                        <th data-field="rname" class="col-sm-1">角色</th>
			                                        <th data-field="eqbscale" class="col-sm-1">比重(%)</th>
				                                    <th data-field="eqbiscommon" data-formatter="eqbiscommonFormatter" class="col-sm-1">是否通用</th>
				                                    <th data-field="eqbisactive" data-formatter="eqbisactiveFormatter" class="col-sm-1">状态</th>
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
        
        	 <!--Start 添加或修改模态窗口 -->
      <div class="modal inmodal" id="modal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">添加员工测评要素</h5>
                  </div>
                 <!--Start 表单 -->
                 <form class="form-horizontal m-t" id="employeeQuestionBasicForm" action="${basePath}/eval/employeeQuestionBasic/addEmployeeQuestionBasic">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="eqbid" name="employeeQuestionBasic.eqbid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">测评要素：</label>
					                   <div class="col-sm-8">
					                       <input id="eqbbasic" name="employeeQuestionBasic.eqbbasic"  minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                       <select id="dtid" name="employeeQuestionBasic.dtid" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择部门类型</option>
		                                    </select>
					                   </div>
					               </div>
					                <div class="form-group">
					                   <label class="col-sm-3 control-label">角色：</label>
					                   <div class="col-sm-8">
					                       <select id="rid" name="employeeQuestionBasic.rid" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择角色</option>
		                                    </select>
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">通用：</label>
					                   <div class="col-sm-8">
					                          <select id="eqbiscommon" name="employeeQuestionBasic.eqbiscommon" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择是否通用</option>
					                       		  <option value="0">不通用</option>
					                       		  <option value="1">通用</option>
		                                    </select>
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
    <script type="text/javascript">
    
    var $table = $("#table");
	var $remove = $("#batchRemove");
    var action = "${basePath}/eval/employeeQuestionBasic/addEmployeeQuestionBasic";
    var text = "添加成功!";
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
	     			data: {},	
	     			async: false,
	     			success: function(data) {
	     				zNodes = data;
	     				var attr  = {"id" : -11,"pId" : 0, "name": "通用类型" };
	     				zNodes.push(attr);
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
			dtid = treeNode.id; //给参数赋值,然后刷新部门列表
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
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/employeeQuestionBasic/getEmployeeQuestionBasicList"});
	    }
	    function getRandom(n){
	        return Math.floor(Math.random()*n+1)
	    }
	    function initDT(){
	    	 $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/eval/employeeQuestionBasic/initDT",	
	     			data: {arg:getRandom(100)},	
	     			async: false,
	     			success: function(data) {
	     				var $dtid = $("#dtid");
	     				$dtid.empty();
	     				$dtid.append('<option value="">请选择部门类型</option>');
	     				$.each(data,function(n,val){
	     					$dtid.append('<option value="'+val.dtid+'">'+val.dtname+'</option');
	     				});
	     			},
	     			error: function(request) {
	     			}
	    		});
	    }
	    function initR(){
	    	 $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/eval/employeeQuestionBasic/initR",	
	     			data: {arg:getRandom(100)},	
	     			async: false,
	     			success: function(data) {
	     				var $rid = $("#rid");
	     				$rid.empty();
	     				$rid.append('<option value="">请选择角色</option>');
	     				$.each(data,function(n,val){
	     					$rid.append('<option value="'+val.rid+'">'+val.rname+'</option');
	     				});
	     			},
	     			error: function(request) {
	     			}
	    		});
	    }
	    window.operateEvents = {
	    		 'click .edit': function (e, value, row) {
	    	            $("#modal .modal-title").text("修改员工测评要素");
	    	        	$("#eqbid").val(row.eqbid);
	    	        	$("#eqbbasic").val(row.eqbbasic);
	    	        	$("#dtid").val(row.dtid);
	    	        	$("#rid").val(row.rid);
	    	    		$("#eqbiscommon").val(row.eqbiscommon);
	    	    		action = "${basePath}/eval/employeeQuestionBasic/editEmployeeQuestionBasic";
	    	    		text = "修改成功!";
	    	      },
	    		 'click .standards': function (e, value, row) {
	    	             layer.open({
	    	                 type: 2,
	    	                 title: ['&nbsp;&nbsp;员工测评标准管理', 'text-align:center;margin:0 auto;font-size:24px;'],
	    	                 shadeClose: false,
	    	                 shade: [0.3, '#393D49'],
	    	                 fix: true,
	    	                 //closeBtn:2,
	    	                 end:function(){
	    	                	 refresh();
	    	                 },
	    	                 //maxmin: true, //开启最大化最小化按钮
	    	                 area: ['85%', '85%'],
	    	                 content: '${basePath}/eval/employeeQuestionStandard?eqbid='+row.eqbid+"&dtid="+row.dtid+"&rid="+row.rid
	    	             });
	    	      },
	    	      'click .update': function (e, value, row) {
	    			 	var text = "启用当前员工测评要素成功!";
	    			 	var eqbisactive = row.eqbisactive;
	    			 	if(eqbisactive==1){
	    			 		text = "停用员工测评要素成功!";
	    			 		eqbisactive = 0;
	    			 	}else{
	    			 		eqbisactive = 1;
	    			 	}
	    				swal({
	    	                title: "修改员工测评要素状态",
	    	                text: "确认启用或停用当前员工测评要素",
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
	     		     			url: "${basePath}/eval/employeeQuestionBasic/updateEmployeeQuestionBasic",	
	     		     			data: {eqbid: row.eqbid,eqbisactive: eqbisactive},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"员工测评要素状态",text:text,timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	      },
   	         'click .remove': function (e, value, row) {
   	        	swal({
   	                title: "删除当前员工测评要素",
   	                text: "删除后将无法恢复，请谨慎操作！",
   	                type: "warning",
   	                showCancelButton: true,
   	                confirmButtonColor: "#DD6B55",
   	                confirmButtonText: "删除",
   	                cancelButtonText: "取消",
   	                closeOnConfirm: false
   	            }, function () {
   	            	 $.ajax({
    		     			cache: false,
    		     			type: "POST",
    		     			url: "${basePath}/eval/employeeQuestionBasic/removeEmployeeQuestionBasic",	
    		     			data: {eqbid: row.eqbid},	
    		     			async: false,
    		     			success: function(data) {
    		     				swal({title:"员工测评要素",text:"删除成功!",timer:2000, type: "success"});
    		     				refresh();
    		     			},
    		     			error: function(request) {
    		     			}
    		    		});
   	            });
   	        }
       };

		    function eqbisactiveFormatter(value, row, index) {
	       	 var str = "";
	       	 if(row.eqbisactive==0){
	       		 str = "已停用";
	       	 }else{
	       		 str = "已启用";
	       	 }
	           return [ str ].join('');
	       }
		    
		    function eqbiscommonFormatter(value, row, index) {
	       	 var str = "";
	       	 if(row.eqbiscommon==0){
	       		 str = "不通用";
	       	 }else{
	       		 str = "通用";
	       	 }
	           return [ str ].join('');
	       }
		   
		    function dtnameFormatter(value, row, index) {
	       	 var str = "";
	       	 if(row.eqbiscommon==0){
	       		 str = row.dtname;
	       	 }else{
	       		 str = "-";
	       	 }
	           return [ str ].join('');
	       }
		    
		    function operateFormatter(value, row, index) {
	        	var text = row.eqbisactive==1?"停用":"启用";
	        	var color = row.eqbisactive==1?"btn-danger":"btn-success"; 
	            return [
	                '<div >',
	                '<button type="button" class="btn update '+color+' btn-sm btn-outline ">',
	                '<i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+text+'</button>',
	                '<button type="button" class="btn standards btn-primary btn-sm btn-outline " ',
	                '><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;标准管理</button>',
	                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
	                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
	                '<button type="button" class="btn remove btn-primary btn-sm btn-outline ">',
	                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
	                '</div>'
	            ].join('');
	        }
	    
	    $(function(){
	    	
	    	 initDT();
	    	 initR();
	    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
	             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
	         });
	    	 $remove.click(function () {
	             var eqbids = $.map($table.bootstrapTable('getSelections'), function (row) {
	                 return row.eqbid;
	             });
	             swal({
		                title: "批量删除员工测评要素",
		                text: "删除后将无法恢复，请谨慎操作！",
		                type: "warning",
		                showCancelButton: true,
		                confirmButtonColor: "#DD6B55",
		                confirmButtonText: "删除",
		                cancelButtonText: "取消",
		                closeOnConfirm: false
		            }, function () {
		            	 $.ajax({
			     			cache: false,
			     			type: "POST",
			     			url: "${basePath}/eval/employeeQuestionBasic/batchRemoveEmployeeQuestionBasic",	
			     			data: {eqbids: eqbids.toString()},	
			     			async: false,
			     			success: function(data) {
			     				swal({title:"员工测评要素",text:"批量删除成功!",timer:2000, type: "success"});
			     				refresh();
			     			},
			     			error: function(request) {
			     			}
			    		});
		            });
	             $remove.prop('disabled', true);
	         });
	    	
	    	$("#close").click(function(){
	    		refresh();
	    		$remove.prop('disabled', true);
	    	});
	    	$("#add").click(function(){
	    		initDT();
	    		initR();
	    		$("#modal .modal-title").text("添加员工测评要素");
	    		$("#eqbid").val("");
	        	$("#eqbbasic").val("");
	        	$("#dtid").val("");
	        	$("#rid").val("");
	    		$("#eqbiscommon").val("");
	    		action = "${basePath}/eval/employeeQuestionBasic/addEmployeeQuestionBasic";
	    		text = "添加成功!";
	    	});
	    	$("#employeeQuestionBasicForm").validate({
	   		    submitHandler: function() {
		   		    $.ajax({
		     			cache: false,
		     			type: "POST",
		     			url: action,	
		     			data: $("#employeeQuestionBasicForm").serialize(),	
		     			async: false,
		     			success: function(data) {
		     				$("#close").click();
		     				swal({title:"员工测评要素",text:text,timer:2000, type: "success"});
		     			},
		     			error: function(request) {
		     			}
		    		});
	   		    }
	    	});
	    });
	    
    </script>
</body>
</html>