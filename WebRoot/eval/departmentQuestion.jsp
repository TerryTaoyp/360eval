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
                        <h2>部门测评问题管理</h2>
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
                                       	部门测评问题列表
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
				                              	data-url="${basePath}/eval/departmentQuestion/getDepartmentQuestionList" 
				                              	data-query-params="queryParams"
				                              >
								            <thead>
									            <tr>
									                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
									                <th data-field="dqid" class="col-sm-1">编号</th>
				                                    <th data-field="dtname" class="col-sm-1">部门类型</th>
			                                        <th data-field="dqbasic" class="col-sm-4">测评要素</th>
				                                    <th data-field="dqscale" class="col-sm-1">比重(%)</th>
				                                    <th data-field="dqisactive" data-formatter="dqisactiveFormatter" class="col-sm-1">状态</th>
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
                      <h5 class="modal-title">添加部门</h5>
                  </div>
                 <!--Start 表单 -->
                 <form class="form-horizontal m-t" id="departmentQuestionForm" action="${basePath}/eval/departmentQuestion/addDepartmentQuestion">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="dqid" name="departmentQuestion.dqid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">测评要素：</label>
					                   <div class="col-sm-8">
					                       <input id="dqbasic" name="departmentQuestion.dqbasic"  minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                       <select id="dtid" name="departmentQuestion.dtid" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择部门类型</option>
		                                    </select>
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">比重(%)：</label>
					                   <div class="col-sm-8">
					                         <input id="dqscale" name="departmentQuestion.dqscale" lonum="0" upnum="100" placeholder="请输入0~100数字" minlength="1" type="text" class="form-control" required="" aria-required="true">
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
    var action = "${basePath}/eval/departmentQuestion/addDepartmentQuestion";
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
	        //console.log(JSON.stringify(params));
	    	return params;
	    }
	    function refresh(){
	    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/departmentQuestion/getDepartmentQuestionList"});
	    }
	    var lonum = 0;
	    var upnum = 100;
	    function getRemainNum(dtid,dqid){
	    	$.ajax({
	 			cache: false,
	 			type: "POST",
	 			url: "${basePath}/eval/departmentQuestion/getRemainNum",	
	 			data: {dtid: dtid,dqid: dqid},	
	 			async: false,
	 			success: function(data) {
	 				$("#dqscale").attr("upnum",data.remainNum);
	 				//alert(data.remainNum);
	 				lonum = $("#dqscale").attr("lonum");
	 				upnum = $("#dqscale").attr("upnum");
	 				if(upnum==lonum){
	 				    $("#dqscale").attr("placeholder","当前剩余比重为0(%)");
	 				}else{
	 					$("#dqscale").attr("placeholder","请输入"+lonum+"~"+upnum+"内数字");
	 				}
	 			},
	 			error: function(request) {
	 			}
			});
	    }
	    function getRandom(n){
	        return Math.floor(Math.random()*n+1)
	    }
	    function init(){
	    	 $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/eval/departmentQuestion/init",	
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
		    		 'click .update': function (e, value, row) {
		    			 	var text = "启用当前部门测评问题成功!";
		    			 	var dqisactive = row.dqisactive;
		    			 	if(dqisactive==1){
		    			 		text = "停用当前部门测评问题成功!";
		    			 		dqisactive = 0;
		    			 	}else{
		    			 		dqisactive = 1;
		    			 	}
		    				swal({
		    	                title: "修改部门测评问题状态",
		    	                text: "确认启用或停用当前部门测评问题",
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
		     		     			url: "${basePath}/eval/departmentQuestion/updateDepartmentQuestion",	
		     		     			data: {dqid: row.dqid,dqisactive: dqisactive},	
		     		     			async: false,
		     		     			success: function(data) {
		     		     				swal({title:"部门测评问题状态",text:text,timer:2000, type: "success"});
		     		     				refresh();
		     		     			},
		     		     			error: function(request) {
		     		     			}
		     		    		});
		    	            });
		    	      },
		    	      'click .options': function (e, value, row) {
		    	             layer.open({
		    	                 type: 2,
		    	                 title: ['&nbsp;&nbsp;部门测评选项管理', 'text-align:center;margin:0 auto;font-size:24px;'],
		    	                 shadeClose: false,
		    	                 shade: [0.3, '#393D49'],
		    	                 fix: true,
		    	                 //maxmin: true, //开启最大化最小化按钮
		    	                 area: ['85%', '85%'],
		    	                 content: '${basePath}/eval/departmentOption?dqid='+row.dqid
		    	             });
		    	      },
		    		 'click .edit': function (e, value, row) {
		    			 	//console.log(JSON.stringify(row));
		    			 	init();
		    	            $(".modal-title").text("修改部门测评问题");
		    	        	$("#dqid").val(row.dqid);
		    	        	$("#dqbasic").val(row.dqbasic);
		    	        	$("#dtid").val(row.dtid);
		    	        	$("#dqscale").val(row.dqscale);
		    	        	getRemainNum(row.dtid,row.dqid);
		    	    		action = "${basePath}/eval/departmentQuestion/editDepartmentQuestion";
		    	    		text = "修改成功!";
		    	      },
	    	         'click .remove': function (e, value, row) {
	    	        	swal({
	    	                title: "删除当前部门测评问题",
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
	     		     			url: "${basePath}/eval/departmentQuestion/removeDepartmentQuestion",	
	     		     			data: {dqid: row.dqid},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"部门测评问题",text:"删除成功!",timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	        }
	        };

		    function dqisactiveFormatter(value, row, index) {
	       	 var str = "";
	       	 if(row.dqisactive==0){
	       		 str = "已停用";
	       	 }else{
	       		 str = "已启用";
	       	 }
	           return [ str ].join('');
	       }
		    
	        function operateFormatter(value, row, index) {
	        	
	        	var text = row.dqisactive==1?"停用":"启用";
	        	var color = row.dqisactive==1?"btn-danger":"btn-success"; 
	            return [
	                '<div >',
	                '<button type="button" class="btn update '+color+' btn-sm btn-outline ">',
	                '<i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+text+'</button>',
	                '<button type="button" class="btn options btn-primary btn-sm btn-outline " ',
	                '><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;选项管理</button>',
	                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
	                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
	                '<button type="button" class="btn remove btn-primary btn-sm btn-outline ">',
	                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
	                '</div>'
	            ].join('');
	        }
	    
	    $(function(){
	    	
	    	$("#dtid").change(function(){
	    		var dtid = $(this).val();
	    		var dqid = $("#dqid").val();
	    		$("#dqscale").val("");
	    		if(dtid==""){
	    			dtid = 0;
	    		}
	    		if(dqid!=0||dqid!=''){
	    			getRemainNum(dtid,dqid);
	    		}else{
	    			getRemainNum(dtid,0);
	    		}
	        });
	    	$("#dqscale").on('change',function(e){
	        	var val =$("#dqscale").val() ;
	        	if(!isNaN(val)){
	        		if(parseInt(val) > parseInt(upnum)){
	            		$("#dqscale").val(upnum);
	            	}else if(parseInt(val) <parseInt(lonum)){
	            		$("#dqscale").val(lonum);
	            	}
	        	}else{
	        		$("#dqscale").val(lonum);
	        	}
	         });
	    	
	    	 init();
	    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
	             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
	         });
	    	 $remove.click(function () {
	             var dqids = $.map($table.bootstrapTable('getSelections'), function (row) {
	                 return row.dqid;
	             });
	             swal({
		                title: "批量删除部门测评问题",
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
			     			url: "${basePath}/eval/departmentQuestion/batchRemoveDepartmentQuestion",	
			     			data: {dqids: dqids.toString()},	
			     			async: false,
			     			success: function(data) {
			     				swal({title:"部门测评问题",text:"批量删除成功!",timer:2000, type: "success"});
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
	    		$(".modal-title").text("添加部门测评问题");
	    		$("#dqid").val("");
	    		$("#dtid").val(dtid==0?"":dtid);
	        	$("#dqbasic").val("");
	    		$("#dqscale").val("");
	    		action = "${basePath}/eval/departmentQuestion/addDepartmentQuestion";
	    		text = "添加成功!";
	    	});
	    	$("#departmentQuestionForm").validate({
	   		    submitHandler: function() {
		   		    $.ajax({
		     			cache: false,
		     			type: "POST",
		     			url: action,	
		     			data: $("#departmentQuestionForm").serialize(),	
		     			async: false,
		     			success: function(data) {
		     				$("#close").click();
		     				swal({title:"部门测评问题",text:text,timer:2000, type: "success"});
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