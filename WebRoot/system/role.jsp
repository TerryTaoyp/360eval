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
	                        <h2>角色管理</h2>
	                    </div>
	                    <div class="ibox-content">
							<div class="btn-group hidden-xs" id="tableToolbar" role="group">
	                                   <button type="button" id="add" class="btn btn-outline btn-primary" data-toggle="modal" data-target="#roleModal">
	                            		 	<i class="glyphicon glyphicon-plus"></i>添加
	                          		</button>
	                                  <button type="button" class="btn  btn-primary" disabled="true" id="batchRemove">
						            <i class="glyphicon glyphicon-remove"></i>批量删除
						        </button>
	                              </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/system/role/getRoleList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
						                <th data-field="rid" class="col-sm-2">编号</th>
	                                       <th data-field="rname" class="col-sm-3">名称</th>
	                                       <th data-field="rtype" data-formatter="rtypeFormatter" class="col-sm-3">类型</th>
	                                       <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-3">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
   		 <!--Start 添加或修改模态窗口 -->
      <div class="modal inmodal" id="roleModal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">添加角色</h5>
                  </div>
                 <form class="form-horizontal m-t" id="roleForm" action="${basePath}/system/role/addRole">
	                 <div class="modal-body">
                      	<!--Start 表单 -->
		        	  	 <div class="ibox-content">
				           	 <input id="rid" name="role.rid"  type="hidden"/>
				               <div class="form-group">
				                   <label class="col-sm-3 control-label">名称：</label>
				                   <div class="col-sm-8">
				                       <input id="rname" name="role.rname"  minlength="2" type="text" class="form-control" required="" aria-required="true">
				                   </div>
				               </div>
				               <div class="form-group">
				                   <label class="col-sm-3 control-label">类型：</label>
				                   <div class="col-sm-8">
				                       <select id="rtype" name="role.rtype" class="form-control m-b" required="" aria-required="true">
				                       		  <option value="">请选择角色类型</option>
				                       		  <option value="0">业务角色</option>
				                       		  <option value="1">系统角色</option>
	                                    </select>
				                   </div>
				               </div>
				       </div>
	        		<!-- End 表单 -->
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
             </div>
         </div>
     </div>
     <!--End 添加或修改模态窗口 -->
     
     
     	 <!--Start 权限设置模态窗口 -->
      <div class="modal inmodal" id="authorityModal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">分配权限</h5>
                  </div>
                  <div class="modal-body">
                   	<div class="ibox-content">
                       <ul id="authorityTree" class="ztree"></ul>
		            </div>
                  </div>
                  	<div class="modal-footer">
                  		 <div class="form-group">
		                   <div class="col-sm-4 col-sm-offset-7">
		                       <button class="btn " id="closeAuthMod" type="button" data-dismiss="modal">关闭</button>
		                       <button class="btn btn-primary"id="confirmAuthMod" type="button">确定</button>
		                   </div>
		                 </div>
	                  </div>
              </div>
          </div>
      </div>
     <!--End 权限设置模态窗口 -->
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
    
	var $table = $("#table");
	var $remove = $("#batchRemove");
    var action = "${basePath}/system/role/addRole";
    var text = "添加成功!";
    var rid = 0;
    var setting = {
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

	var zNodes =[];
	function getZNodes(rid){
		
		 $.ajax({
    			cache: false,
    			type: "POST",
    			url: "${basePath }/system/authority/getAuthorityTree",	
    			data: {rid:rid},	
    			async: false,
    			success: function(data) {
    				zNodes = data;
    				$.fn.zTree.init($("#authorityTree"), setting, zNodes);
    				$.fn.zTree.getZTreeObj("authorityTree").expandAll(true);
    			},
			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
                   //alert(XMLHttpRequest.status);
                   //alert(XMLHttpRequest.readyState);
                   //alert(textStatus);
               }
   		});
	}

	//自定义数据参数
	var pa;
    function queryParams(params) {
    	//params.ni = "ni"; //自定义参数
        //console.log(JSON.stringify(params));
    	pa = params;
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/system/role/getRoleList",query: {offset: pa.offset}});
    }
    function getRandom(n){
        return Math.floor(Math.random()*n+1)
    }
    window.operateEvents = {
				  'click .distri': function (e, value, row) {
					  rid = row.rid;
					  getZNodes(row.rid);
				  },
	    		 'click .edit': function (e, value, row) {
	    	            $("#roleModal .modal-title").text("修改角色");
	    	        	$("#rid").val(row.rid);
	    	        	$("#rname").val(row.rname);
	    	        	$("#rname").attr("readonly","readonly");
	    	        	$("#rtype").val(row.rtype);
	    	    		action = "${basePath}/system/role/updateRole";
	    	    		text = "修改成功!";
	    	      },
    	         'click .remove': function (e, value, row) {
    	        	swal({
    	                title: "删除当前角色",
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
     		     			url: "${basePath}/system/role/removeRole",	
     		     			data: {rid: row.rid},	
     		     			async: false,
     		     			success: function(data) {
     		     				swal({title:"角色",text:"删除成功!",timer:2000, type: "success"});
     		     				refresh();
     		     			},
     		     			error: function(request) {
     		     			}
     		    		});
    	            });
    	        }
        };
		
        function rtypeFormatter(value, row, index) {
        	 var str = "";
        	 if(row.rtype==0){
        		 str = "业务角色";
        	 }else{
        		 str = "系统角色";
        	 }
            return [ str ].join('');
        }
        function operateFormatter(value, row, index) {
            return [
                '<div >',
                '<button type="button" class="btn distri btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#authorityModal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;分配权限</button>',
                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#roleModal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
                '<button type="button" class="btn remove btn-primary btn-sm btn-outline ">',
                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
                '</div>'
            ].join('');
        }
     
     function getChildNodes(treeNode) {
         var childNodes = ztree.transformToArray(treeNode);
         var nodes = new Array();
         for(var i = 0; i < childNodes.length; i++) {
              nodes[i] = childNodes[i].id;
         }
         return nodes.join(",");
    }
	
    $(function(){
    	$("#confirmAuthMod").click(function(){
    		var nodes = $.fn.zTree.getZTreeObj("authorityTree").getCheckedNodes(true);
    		//alert("nodes:"+nodes.length+"  url:"+nodes[0].url);
    		var aidsArr = new Array();
            for(var i = 0; i < nodes.length; i++) {
            	aidsArr[i] = nodes[i].id;
            }
            var aids = aidsArr.join(",");
            //alert("rid==="+rid+"==="+aids);
            $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/system/role/distriAuthority",	
	     			data: {rid: rid,aids: aids},	
	     			async: false,
	     			success: function(data) {
	     				$("#closeAuthMod").click();
	     				swal({title:"角色权限",text:"分配成功!",timer:2000, type: "success"});
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
             var rids = $.map($table.bootstrapTable('getSelections'), function (row) {
                 return row.rid;
             });
             swal({
	                title: "批量删除角色",
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
		     			url: "${basePath}/system/role/batchRemoveRole",	
		     			data: {rids: rids.toString()},	
		     			async: false,
		     			success: function(data) {
		     				swal({title:"角色",text:"批量删除成功!",timer:2000, type: "success"});
		     				refresh();
		     			},
		     			error: function(request) {
		     			}
		    		});
	            });
             $remove.prop('disabled', true);
         });
    	
    	$("#add").click(function(){
    		$("#roleModal .modal-title").text("添加角色");
    		$("#rid").val("");
        	$("#rname").val("");
        	$("#rname").removeAttr("readonly");
    		$("#rtype").val("");
    		action = "${basePath}/system/role/addRole";
    		text = "添加成功!";
    	});
    	$("#roleForm").validate({
   		    submitHandler: function() {
	   		    $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: action,	
	     			data: $("#roleForm").serialize(),	
	     			async: false,
	     			success: function(data) {
	     				$("#close").click();//触发点击事件
	     				swal({title:"角色",text:text,timer:2000, type: "success"});
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