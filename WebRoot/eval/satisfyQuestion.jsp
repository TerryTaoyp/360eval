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

    <link rel="shortcut icon" href="favicon.ico"> 
    <link href="${basePath }/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
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
	                        <h2>满意度问题管理</h2>
	                    </div>
	                    <div class="ibox-content">
							<div class="btn-group hidden-xs" id="tableToolbar" role="group">
	                                  <button type="button" id="add" class="btn btn-outline btn-primary" data-toggle="modal" data-target="#modal">
	                            		 	<i class="glyphicon glyphicon-plus"></i>添加
	                          		 </button>
	                          		 <button type="button" id="options" class="btn options btn-outline btn-primary">
	                            		 	<i class="glyphicon glyphicon-edit"></i>选项管理
	                          		 </button>
	                                  <button type="button" class="btn  btn-primary" disabled="true" id="batchRemove">
							            <i class="glyphicon glyphicon-remove"></i>批量删除
							        </button>
	                              </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/eval/satisfyQuestion/getSatisfyQuestionList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
						                <th data-field="sqid" class="col-sm-1">编号</th>
                                        <th data-field="sqname" class="col-sm-4">问题</th>
                                        <th data-field="sqtype" data-formatter="sqtypeFormatter" class="col-sm-1">类型</th>
                                        <th data-field="sqisactive" data-formatter="sqisactiveFormatter" class="col-sm-1">状态</th>
                                        <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-4">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
   		 <!--Start 添加或修改模态窗口 -->
      <div class="modal inmodal" id="modal" tabindex="100" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">添加满意度问题</h5>
                  </div>
                  	<!--Start 表单 -->
                <form class="form-horizontal m-t" id="satisfyQuestionForm" action="${basePath}/eval/satisfyQuestion/addSatisfyQuestion">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="sqid" name="satisfyQuestion.sqid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">问题：</label>
					                   <div class="col-sm-8">
					                       <input id="sqname" name="satisfyQuestion.sqname"  minlength="1" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                     	<select id="sqtype" name="satisfyQuestion.sqtype" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择问题类型</option>
					                       		  <option value="0">封闭问题</option>
					                       		  <option value="1">开放问题</option>
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
	var $remove = $("#batchRemove");
    var action = "${basePath}/eval/satisfyQuestion/addSatisfyQuestion";
    var text = "添加成功!";
    
  	//自定义数据参数
    function queryParams(params) {
        //console.log(JSON.stringify(params));
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/satisfyQuestion/getSatisfyQuestionList"});
    }

    window.operateEvents = {
	    		 'click .edit': function (e, value, row) {
	    	            $("#modal .modal-title").text("修改满意度问题");
	    	        	$("#sqid").val(row.sqid);
	    	        	$("#sqname").val(row.sqname);
	    	    		$("#sqtype").val(row.sqtype);
	    	    		action = "${basePath}/eval/satisfyQuestion/editSatisfyQuestion";
	    	    		text = "修改成功!";
	    	      },
	    	      'click .update': function (e, value, row) {
	    			 	var text = "启用当前满意度问题成功!";
	    			 	var sqisactive = row.sqisactive;
	    			 	if(sqisactive==1){
	    			 		text = "停用当前满意度问题成功!";
	    			 		sqisactive = 0;
	    			 	}else{
	    			 		sqisactive = 1;
	    			 	}
	    				swal({
	    	                title: "修改满意度问题状态",
	    	                text: "确认启用或停用当前满意度问题",
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
	     		     			url: "${basePath}/eval/satisfyQuestion/updateSatisfyQuestion",	
	     		     			data: {sqid: row.sqid,sqisactive: sqisactive},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"满意度问题状态",text:text,timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	      },
    	         'click .remove': function (e, value, row) {
    	        	swal({
    	                title: "删除当前满意度问题",
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
     		     			url: "${basePath}/eval/satisfyQuestion/removeSatisfyQuestion",	
     		     			data: {sqid: row.sqid},	
     		     			async: false,
     		     			success: function(data) {
     		     				swal({title:"满意度问题",text:"删除成功!",timer:2000, type: "success"});
     		     				refresh();
     		     			},
     		     			error: function(request) {
     		     			}
     		    		});
    	            });
    	        }
        };

	    function sqisactiveFormatter(value, row, index) {
	   	 var str = "";
	   	 if(row.sqisactive==0){
	   		 str = "已停用";
	   	 }else{
	   		 str = "已启用";
	   	 }
	       return [ str ].join('');
		   }
	    function sqtypeFormatter(value, row, index) {
	   	 var str = "";
	   	 if(row.sqtype==0){
	   		 str = "封闭问题";
	   	 }else{
	   		 str = "开放问题";
	   	 }
	       return [ str ].join('');
		   }
        function operateFormatter(value, row, index) {
        	var text = row.sqisactive==1?"停用":"启用";
        	var color = row.sqisactive==1?"btn-danger":"btn-success"; 
            return [
                '<div >',
                '<button type="button" class="btn update '+color+' btn-sm btn-outline ">',
                '<i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+text+'</button>',
                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
                '<button type="button" class="btn remove btn-primary btn-sm btn-outline ">',
                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
                '</div>'
            ].join('');
        }
    
        
    $(function(){
    	
        $("#options").click(function(){
        	   layer.open({
	                 type: 2,
	                 title: ['&nbsp;&nbsp;满意度选项管理', 'text-align:center;margin:0 auto;font-size:24px;'],
	                 shadeClose: false,
	                 shade: [0.3, '#393D49'],
	                 fix: true,
	                  area: ['85%', '85%'],
	                 content: '${basePath}/eval/grade'
	             });
        });
    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
         })
    	 $remove.click(function () {
             var sqids = $.map($table.bootstrapTable('getSelections'), function (row) {
                 return row.sqid;
             });
             swal({
	                title: "批量删除满意度问题",
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
		     			url: "${basePath}/eval/satisfyQuestion/batchRemoveSatisfyQuestion",	
		     			data: {sqids: sqids.toString()},	
		     			async: false,
		     			success: function(data) {
		     				swal({title:"满意度问题",text:"批量删除成功!",timer:2000, type: "success"});
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
    	});
    	
    	$("#add").click(function(){
    		$("#modal .modal-title").text("添加满意度问题");
    		$("#sqid").val("");
        	$("#sqname").val("");
    		$("#sqtype").val("");
    		action = "${basePath}/eval/satisfyQuestion/addSatisfyQuestion";
    		text = "添加成功!";
    	});
    	$("#satisfyQuestionForm").validate({
   		    submitHandler: function() {
	   		    $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: action,	
	     			data: $("#satisfyQuestionForm").serialize(),	
	     			async: false,
	     			success: function(data) {
	     				$("#close").click();
	     				swal({title:"满意度问题",text:text,timer:2000, type: "success"});
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