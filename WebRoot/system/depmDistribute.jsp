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
	                        <h2>管辖分配</h2>
	                    </div>
	                    <div class="ibox-content">
								 <div class="btn-group hidden-xs" id="tableToolbar" role="group">
	                              </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/system/depmDistribute/getDempDistributeList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                   <th data-field="eid" class="col-sm-1">编号</th>
	                                       <th data-field="zname" class="col-sm-2">姓名</th>
	                                       <th data-field="rname" class="col-sm-2">角色</th>
	                                       <th data-field="dnames" class="col-sm-4">管辖部门</th>
	                                       <th data-formatter="operateFormatter" data-events="operateEvents"  class="col-sm-3">操作</th>
						            </tr>
					            </thead>
					        </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
     
     	 <!--Start 权限设置模态窗口 -->
      <div class="modal inmodal" id="authorityModal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">管辖部门</h5>
                  </div>
                  <div class="modal-body">
                   	<div class="ibox-content">
                       <ul id="departmentTree" class="ztree"></ul>
		            </div>
                  </div>
                  	<div class="modal-footer">
                  		 <div class="form-group">
		                   <div class="col-sm-4 col-sm-offset-7">
		                       <button class="btn " id="closeDmMod" type="button" data-dismiss="modal">关闭</button>
		                       <button class="btn btn-primary"id="confirmDmMod" type="button">确定</button>
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
    
    var eid = 0;
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
					var zTree = $.fn.zTree.getZTreeObj("departmentTree");
					zTree.expandNode(treeNode);
				}
			}
		};

	var zNodes =[];
	function getZNodes(eid,rid){
		
		 $.ajax({
    			cache: false,
    			type: "POST",
    			url: "${basePath }/system/department/getDepartmentTreeCheck",	
    			data: {eid: eid,rid: rid},	
    			async: false,
    			success: function(data) {
    				zNodes = data;
    				$.fn.zTree.init($("#departmentTree"), setting, zNodes);
    				$.fn.zTree.getZTreeObj("departmentTree").expandAll(true);
    			},
			 	error: function(XMLHttpRequest, textStatus, errorThrown) {
               }
   		});
	}

	//自定义数据参数
	var pa;
    function queryParams(params) {
    	pa = params;
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/system/depmDistribute/getDempDistributeList",query: {offset: pa.offset}});
    }
    function getRandom(n){
        return Math.floor(Math.random()*n+1);
    }
    window.operateEvents = {
				  'click .distri': function (e, value, row) {
					  eid = row.eid;
					  rid = row.rid;
					  getZNodes(row.eid,row.rid);
				  }
        };
		
        function operateFormatter(value, row, index) {
            return [
                '<div >',
                '<button type="button" class="btn distri btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#authorityModal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;分配部门</button>',
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
    	$("#confirmDmMod").click(function(){
    		var nodes = $.fn.zTree.getZTreeObj("departmentTree").getCheckedNodes(true);
    		var didsArr = new Array();
            for(var i = 0; i < nodes.length; i++) {
            	if(!nodes[i].isParent){//只留下叶节点
            		didsArr.push(nodes[i].id);
            	}
            }
            var dids = didsArr.join(",");
            $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/system/depmDistribute/addDepmDistribute",	
	     			data: {eid: eid,rid: rid,dids: dids},	
	     			async: false,
	     			success: function(data) {
	     				$("#closeDmMod").click();
	     				swal({title:"部门管辖",text:"分配成功!",timer:2000, type: "success"});
	     				refresh();
	     			},
	     			error: function(request) {
	     			}
	    		});
    	});
    });
    
    </script>
</body>
</html>