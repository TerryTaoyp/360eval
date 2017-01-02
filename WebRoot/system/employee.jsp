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
                    <div class="ibox-title text-center">
                        <h2>人员管理</h2>
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
										            <i class="glyphicon glyphicon-remove"></i>批量删除
										        </button>
				                              </div>
				                              <table 
				                              	id="table" 
				                              	data-toggle="table" 
				                              	data-url="${basePath}/system/employee/getEmployeeList" 
				                              	data-query-params="queryParams"
				                              >
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="eid" class="col-sm-1">编号</th>
			                                        <th data-field="zname" data-sortable="true" class="col-sm-1">名字</th>
			                                        <th data-field="sex" data-formatter="sexFormatter" class="col-sm-1">性别</th>
			                                        <th data-field="card" class="col-sm-1">身份证号</th>
			                                        <th data-field="dname" class="col-sm-1">部门</th>
			                                        <th data-field="rnames" class="col-sm-1">角色</th>
				                                    <th data-field="isactive" data-formatter="isactiveFormatter" class="col-sm-1">状态</th>
				                                    <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-4">操作</th>
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
                      <h5 class="modal-title">修改人员</h5>
                  </div>
                 <!--Start 表单 -->
                 <form class="form-horizontal m-t" id="employeeForm" action="${basePath}/system/employee/editEmployee">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="eid" name="employee.eid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">姓名：</label>
					                   <div class="col-sm-8">
					                       <input id="zname" name="employee.zname"  readonly="readonly" minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">部门：</label>
					                   <div class="col-sm-8">
					                       <select id="did" name="employee.did" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择部门</option>
					                       		  <c:forEach items="${departmentList}" var="dm">
					                       		  	<option value="${dm.did }">${dm.dname }</option>
					                       		  </c:forEach>
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
	         <!--Start 权限设置模态窗口 -->
	      <div class="modal inmodal" id="roleModal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
	          <div class="modal-dialog">
	              <div class="modal-content animated bounce">
	                  <div class="modal-header">
	                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
	                      <h5 class="modal-title">分配角色</h5>
	                  </div>
	                  <div class="modal-body">
	                   	<div class="ibox-content">
	                       <ul id="roleTree" class="ztree"></ul>
			            </div>
	                  </div>
	                  	<div class="modal-footer">
	                  		 <div class="form-group">
			                   <div class="col-sm-4 col-sm-offset-7">
			                       <button class="btn " id="closeRoleMod" type="button" data-dismiss="modal">关闭</button>
			                       <button class="btn btn-primary"id="confirmRoleMod" type="button">确定</button>
			                   </div>
			                 </div>
		                  </div>
	              </div>
	          </div>
	      </div>
	     <!--End 权限设置模态窗口 -->
        
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
    <script src="${basePath }/js/plugins/iCheck/icheck.min.js"></script>
    <script type="text/javascript">
    
    var $table = $("#table");
	var $remove = $("#batchRemove");
	var eid = 0;
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
	     			data: {},	
	     			async: false,
	     			success: function(data) {
	     				zNodes = data;
	     				$.fn.zTree.init($("#departmentTree"), setting, zNodes);
	     			},
     			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
                        //alert(XMLHttpRequest.status);
                        //alert(XMLHttpRequest.readyState);
                        //alert(textStatus);
                    }
	    		});
		}
		
	 	var roleSetting = {
				check: {
					enable: true,
					chkboxType :{ "Y" : "ps", "N" : "ps" }
				},
				data: {
					simpleData: {
						enable: true
					}
				},
				view: {
					fontCss : {"color":"#1AB394","font-weight":"500"},
					dblClickExpand: false,
					showLine: false
				},
				callback: {
					onClick: function(e,treeId,treeNode){
						var zTree = $.fn.zTree.getZTreeObj("authorityTree");
						zTree.expandNode(treeNode);
					}
				}
			};

		var roleZNodes =[];
		
		function getRoleZNodes(rid){
			 $.ajax({
	    			cache: false,
	    			type: "POST",
	    			url: "${basePath }/system/role/getRoleTree",	
	    			data: {eid:eid},	
	    			async: false,
	    			success: function(data) {
	    				roleZNodes = data;
	    				$.fn.zTree.init($("#roleTree"), roleSetting, roleZNodes);
	    				$.fn.zTree.getZTreeObj("roleTree").expandAll(true);
	    			},
				 	error: function(XMLHttpRequest, textStatus, errorThrown) {
	                   //alert(XMLHttpRequest.status);
	                   //alert(XMLHttpRequest.readyState);
	                   //alert(textStatus);
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
		
		var pa;
	  	//自定义数据参数
	    function queryParams(params) {
	    	params.did = did; //自定义参数
	    	params.dtid = dtid; //自定义参数
	    	pa = params;
	    	return params;
	    }
	    function refresh(){
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/system/employee/getEmployeeList",query: {offset: pa.offset}});
	    }
	    window.operateEvents = {
		    		 'click .update': function (e, value, row) {
		    			 	var text = "启用当前人员成功!";
		    			 	var isactive = row.isactive;
		    			 	if(isactive==1){
		    			 		text = "停用当前人员成功!";
		    			 		isactive = 0;
		    			 	}else{
		    			 		isactive = 1;
		    			 	}
		    				swal({
		    	                title: "修改人员状态",
		    	                text: "确认启用或停用当前人员",
		    	                type: "warning",
		    	                showCancelButton: true,
		    	                confirmButtonColor: "#DD6B55",
		    	                confirmButtonText: "确定",
		    	                cancelButtonText: "取消",
		    	                closeOnConfirm: false
		    	            }, function () {
		    	            	 $.ajax({
		     		     			cache: false,
		     		     			type: "POST",	//${basePath}/system/employee/getEmployeeList
		     		     			url: "${basePath}/system/employee/updateEmployee",	
		     		     			data: {eid: row.eid,isactive: isactive},	
		     		     			async: false,
		     		     			success: function(data) {
		     		     				swal({title:"人员状态",text:text,timer:2000, type: "success"});
		     		     				refresh();
		     		     			},
		     		     			error: function(request) {
		     		     			}
		     		    		});
		    	            });
		    	      },
		    	      'click .edit': function (e, value, row) {
		    	        	$("#eid").val(row.eid);
		    	        	$("#zname").val(row.zname);
		    	        	$("#did").val(row.did);
		    	      },
		    	      'click .distriRole': function (e, value, row) {
		    	    	  eid = row.eid;
		    	    	  getRoleZNodes(row.eid);
		    	      },
		    	      
	    	         'click .reset': function (e, value, row) {
	    	        	swal({
	    	                title: "重置当前人员密码",
	    	                text: "默认密码000000，请谨慎操作！",
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
	     		     			url: "${basePath}/system/employee/resetEmployee",	
	     		     			data: {eid: row.eid},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"人员",text:"重置密码成功!",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	        },
		    	      'click .distriRole': function (e, value, row) {
		    	    	  eid = row.eid;
		    	    	  getRoleZNodes(row.eid);
		    	      },
	    	         'click .remove': function (e, value, row) {
	    	        	swal({
	    	                title: "删除当前人员",
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
	     		     			url: "${basePath}/system/employee/removeEmployee",	
	     		     			data: {eid: row.eid},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"人员",text:"删除成功!",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	        }
	        };
			
		    function sexFormatter(value, row, index) {
	       	   var str = "";
	       	   if(row.sex==0){
	       		   str = "男";
	       	   }else{
	       		   str = "女";
	       	   }
	           return [ str ].join('');
	        }
		    
		    function isactiveFormatter(value, row, index) {
	        	 var str = "";
	        	 if(row.isactive==0){
	        		 str = "已停用";
	        	 }else{
	        		 str = "已启用";
	        	 }
	            return [ str ].join('');
	        }
		    
	        function operateFormatter(value, row, index) {
	        	var text = row.isactive==1?"停用":"启用";
	        	var color = row.isactive==1?"btn-danger":"btn-success"; 
	            return [
	                '<div >',
	                '<button type="button" class="btn update '+color+' btn-sm btn-outline ">',
	                '<i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+text+'</button>',
	                '<button type="button" class="btn distriRole btn-primary btn-sm btn-outline"',
	                ' data-toggle="modal" data-target="#roleModal">',
	                '<i class="glyphicon glyphicon-edit"></i>&nbsp;&nbsp;分配角色</button>',
	                '<button type="button" class="btn edit btn-primary btn-sm btn-outline"',
	                ' data-toggle="modal" data-target="#modal">',
	                '<i class="glyphicon glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
	                '<button type="button" class="btn reset btn-primary btn-sm btn-outline">',
	                '<i class="glyphicon glyphicon-edit"></i>&nbsp;&nbsp;重置密码</button>',
	                '<button type="button" class="btn remove btn-primary btn-sm btn-outline">',
	                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
	                '</div>'
	            ].join('');
	        }
	   
        $(function(){
        	
        	$("#confirmRoleMod").click(function(){
        		var nodes = $.fn.zTree.getZTreeObj("roleTree").getCheckedNodes(true);
        		var ridsArr = new Array();
                for(var i = 0; i < nodes.length; i++) {
                	ridsArr[i] = nodes[i].id;
                }
                var rids = ridsArr.join(",");
                $.ajax({
    	     			cache: false,
    	     			type: "POST",
    	     			url: "${basePath}/system/employee/distriRole",	
    	     			data: {eid: eid,rids: rids},	
    	     			async: false,
    	     			success: function(data) {
    	     				$("#closeRoleMod").click();
    	     				swal({title:"人员角色",text:"分配成功!",timer:2000, type: "success"});
    	     				refresh();
    	     			},
    	     			error: function(request) {
    	     			}
    	    		});
        	});
	    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
	             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
	         })
	    	 $remove.click(function () {
	             var eids = $.map($table.bootstrapTable('getSelections'), function (row) {
	                 return row.eid;
	             });
	             swal({
		                title:"批量删除人员",
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
			     			url: "${basePath}/system/employee/batchRemoveEmployee",	
			     			data: {eids: eids.toString()},	
			     			async: false,
			     			success: function(data) {
			     				swal({title:"人员",text:"批量删除成功!",timer:2000, type: "success"});
			     				refresh();
			     			},
			     			error: function(request) {
			     			}
			    		});
		            });
	             $remove.prop('disabled', true);
	         });
	    	 
	    	 $("#employeeForm").validate({
		   		    submitHandler: function() {
			   		    $.ajax({
			     			cache: false,
			     			type: "POST",
			     			url: "${basePath}/system/employee/editEmployee",	
			     			data:  $("#employeeForm").serialize(),	
			     			async: false,
			     			success: function(data) {
			     				$("#close").click();
			     				swal({title:"人员",text:"修改成功",timer:2000, type: "success"});
			     				refresh();
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