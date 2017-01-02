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
	    <!-- Start 当前表格开始 -->
	    <div class="row">
	            <div class="col-sm-12">
	                <div class="ibox">
	                    <div class="ibox-title text-center">
	                        <h2>权限管理</h2>
	                    </div>
	                    <div class="ibox-content">
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
	                              	data-url="${basePath}/system/authority/getAuthorityList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
						                <th data-field="aid" class="col-sm-1">编号</th>
	                                       <th data-field="aname" class="col-sm-2">名称</th>
	                                       <th data-field="apath" class="col-sm-3">路径</th>
	                                       <th data-field="paname" class="col-sm-2">父权限</th>
	                                       <th data-field="atype" data-formatter="atypeFormatter" class="col-sm-1">类型</th>
	                                       <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-2">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
   		 <!--Start 添加或修改模态窗口 -->
      <div class="modal inmodal" id="modal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">添加权限</h5>
                  </div>
                  <!--Start 表单 -->
                    <form class="form-horizontal m-t" id="authorityForm" action="${basePath}/system/authority/addAuthority">
	                 <div class="modal-body">
		        	  	 <div class="ibox-content">
				            	 <input id="aid" name="authority.aid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">名称：</label>
					                   <div class="col-sm-8">
					                       <input id="aname" name="authority.aname"  minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">路径：</label>
					                   <div class="col-sm-8">
					                       <input id="apath" name="authority.apath"  minlength="1" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">父权限：</label>
					                   <div class="col-sm-8">
					                       <select id="aparent" name="authority.aparent" class="form-control m-b" required="" aria-required="true">
					                       		  <option value="0">请选择父权限</option>
		                                    </select>
					                   </div>
					               </div>
					                 <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                       <select id="atype" name="authority.atype" class="form-control m-b"  required="" aria-required="true" >
					                       		  <option value="">请选择权限类型</option>
					                       		  <option value="0">菜单</option>
					                       		  <option value="1">按钮</option>
		                                    </select>
					                   </div>
					               </div>
				       </div>
	                  </div>
	                  <div class="modal-footer">
                  		 <div class="form-group">
		                   <div class="col-sm-4 col-sm-offset-7">
		                       <button class="btn btn-white" id="close" type="button" data-dismiss="modal">关闭</button>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
	var $table = $("#table");
	var $remove = $("#batchRemove");
    var action = "${basePath}/system/authority/addAuthority";
    var text = "添加成功!";
    
  	//表格其他属性  行变色data-row-style="rowStyle" 高度data-height="485"
  	//自定义数据参数
  	var pa;
    function queryParams(params) {
    	//params.ni = "ni"; //自定义参数
        //console.log(JSON.stringify(params));
    	pa = params;
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/system/authority/getAuthorityList",query: {offset: pa.offset}});
    }
    function getRandom(n){
        return Math.floor(Math.random()*n+1)
    }
    function init(){
   	 	$.ajax({
    			cache: false,
    			type: "POST",
    			url: "${basePath}/system/authority/init",	
    			data: {arg:getRandom(100)},	
    			async: false,
    			success: function(data) {
    				var $aparent = $("#aparent");
    				$aparent.empty();
    				$aparent.append('<option value="">请选择父权限</option>');
    				$aparent.append('<option value="0">无父权限</option>');
    				$.each(data,function(n,val){
    					$aparent.append('<option value="'+val.aid+'">'+val.aname+'</option');
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
	    	            $(".modal-title").text("修改权限");
	    	        	$("#aid").val(row.aid);
	    	        	$("#aname").val(row.aname);
	    	        	$("#apath").val(row.apath);
	    	    		$("#aparent").val(row.aparent);
	    	    		$("#atype").val(row.atype);
	    	    		action = "${basePath}/system/authority/updateAuthority";
	    	    		text = "修改成功!";
	    	      },
    	         'click .remove': function (e, value, row) {
    	        	swal({
    	                title: "删除当前权限",
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
     		     			url: "${basePath}/system/authority/removeAuthority",	
     		     			data: {aid: row.aid},	
     		     			async: false,
     		     			success: function(data) {
     		     				swal({title:"权限",text:"删除成功!",timer:2000, type: "success"});
     		     				refresh();
     		     			},
     		     			error: function(request) {
     		     			}
     		    		});
    	            });
    	        }
        };

	    function atypeFormatter(value, row, index) {
	   	 var str = "";
	   	 if(row.atype==0){
	   		 str = "菜单";
	   	 }else{
	   		 str = "按钮";
	   	 }
	       return [ str ].join('');
	   }
        function operateFormatter(value, row, index) {
            return [
                '<div >',
                '<button type="button" class="btn edit btn-primary btn-sm btn-outline" ',
                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
                '<button type="button" class="btn remove btn-primary btn-sm btn-outline">',
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
             var aids = $.map($table.bootstrapTable('getSelections'), function (row) {
                 return row.aid;
             });
             //console.log(dtids.toString());
             /*$table.bootstrapTable('remove', {
                 field: 'dtid',
                 values: ids
             });*/
             swal({
	                title: "批量删除权限",
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
		     			url: "${basePath}/system/authority/batchRemoveAuthority",	
		     			data: {aids: aids.toString()},	
		     			async: false,
		     			success: function(data) {
		     				swal({title:"权限",text:"批量删除成功!",timer:2000, type: "success"});
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
    		init();
    		$(".modal-title").text("添加权限");
    		$("#aid").val("");
        	$("#aname").val("");
        	$("#apath").val("");
    		$("#aparent").val("");
    		$("#atype").val("");
    		action = "${basePath}/system/authority/addAuthority";
    		text = "添加成功!";
    	});
    	$("#authorityForm").validate({
   		    submitHandler: function() {
	   		    $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: action,	
	     			data: $("#authorityForm").serialize(),	
	     			async: false,
	     			success: function(data) {
	     				$("#close").click();
	     				swal({title:"权限",text:text,timer:2000, type: "success"});
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