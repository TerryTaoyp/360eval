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
    <base target="_blank">
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title text-center">
                        <h2>部门管理</h2>
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
                                       	部门列表
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
				                              	data-url="${basePath}/system/department/getDepartmentList" 
				                              	data-query-params="queryParams"
				                              >
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="did" class="col-sm-1">编号</th>
			                                        <th data-field="dname" class="col-sm-2">名称</th>
			                                        <th data-field="dtname" class="col-sm-2">类型</th>
				                                    <th data-field="ddescribe" class="col-sm-3">描述</th>
				                                    <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-2">操作</th>
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
                      <h5 class="modal-title">添加部门</h5>
                  </div>
                 <!--Start 表单 -->
                 <form class="form-horizontal m-t" id="departmentForm" action="${basePath }/addDeparment">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="did" name="department.did"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">名称：</label>
					                   <div class="col-sm-8">
					                       <input id="dname" name="department.dname"  minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                       <select id="dtid" name="department.dtid" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择部门类型</option>
		                                    </select>
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">描述：</label>
					                   <div class="col-sm-8">
					                       <textarea id="ddescribe" name="department.ddescribe"  class="form-control" required="" aria-required="true"></textarea>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
    var $table = $("#table");
	var $remove = $("#batchRemove");
    var action = "${basePath}/system/department/addDeparment";
    var text = "添加成功!";
    var dtid = 0;
    var setting = {
			data: {
				key: {
					title:"t"
				},
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
	     				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
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
			dtid = treeNode.id; //给参数赋值,然后刷新部门列表
			refresh();
		}		

		$(document).ready(function(){
			getZNodes();
			//console.log(JSON.stringify(zNodes));
			//$.fn.zTree.init($("#treeDemo"), setting, zNodes);
		});
		
	  	//自定义数据参数
	  	var pa;
	    function queryParams(params) {
	    	params.dtid = dtid; //自定义参数
	        //console.log(JSON.stringify(params));
	    	pa = params;
	    	return params;
	    }
	    function refresh(){
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/system/department/getDepartmentList",query: {offset: pa.offset}});
	    }
	    function getRandom(n){
	        return Math.floor(Math.random()*n+1)
	    }
	    function init(){
	    	 $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/system/department/init",	
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
	    window.operateEvents = {
		    		 'click .edit': function (e, value, row) {
		    			 	//console.log(JSON.stringify(row));
		    			 	init();
		    	            $(".modal-title").text("修改部门");
		    	        	$("#did").val(row.did);
		    	        	$("#dname").val(row.dname);
		    	        	$("#dtid").val(row.dtid);
		    	    		$("#ddescribe").val(row.ddescribe);
		    	    		action = "${basePath}/system/department/updateDeparment";
		    	    		text = "修改成功!";
		    	      },
	    	         'click .remove': function (e, value, row) {
	    	        	swal({
	    	                title: "删除当前部门",
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
	     		     			url: "${basePath}/system/department/removeDeparment",	
	     		     			data: {did: row.did},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"部门",text:"删除成功!",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	        }
	        };

	        function operateFormatter(value, row, index) {
	            return [
	                '<div >',
	                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
	                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
	                '<button type="button" class="btn remove btn-primary btn-sm btn-outline ">',
	                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
	                '</div>'
	            ].join('');
	        }
	    
	    $(function(){
	    	
	    	 init();
	    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
	             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
	         })
	    	 $remove.click(function () {
	             var dids = $.map($table.bootstrapTable('getSelections'), function (row) {
	                 return row.did;
	             });
	             console.log(dids.toString());
	             /*$table.bootstrapTable('remove', {
	                 field: 'did',
	                 values: ids
	             });*/
	             swal({
		                title: "批量删除部门",
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
			     			url: "${basePath}/system/department/batchRemoveDeparment",	
			     			data: {dids: dids.toString()},	
			     			async: false,
			     			success: function(data) {
			     				swal({title:"部门",text:"批量删除成功!",timer:2000, type: "success"});
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
	    		init();
	    		$(".modal-title").text("添加部门");
	    		$("#did").val("");
	    		$("#dtid").val(dtid==0?"":dtid);
	    		$("#dname").val("");
	    		$("#ddescribe").val("");
	    		action = "${basePath}/system/department/addDeparment";
	    		text = "添加成功!";
	    	});
	    	$("#departmentForm").validate({
	   		    submitHandler: function() {
		   		    $.ajax({
		     			cache: false,
		     			type: "POST",
		     			url: action,	
		     			data: $("#departmentForm").serialize(),	
		     			async: false,
		     			success: function(data) {
		     				$("#close").click();
		     				swal({title:"部门",text:text,timer:2000, type: "success"});
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