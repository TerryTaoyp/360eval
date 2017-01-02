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
	                        <h2>测评计划管理</h2>
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
	                              	data-url="${basePath}/eval/statistic/getStatisticList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
						                <th data-field="sid" class="col-sm-1">编号</th>
	                                       <th data-field="sname" class="col-sm-2">名称</th>
	                                       <th data-field="stime" class="col-sm-2">开始时间</th>
	                                       <th data-field="etime" class="col-sm-2">结束时间</th>
	                                       <th data-field="stype" data-formatter="stypeFormatter" class="col-sm-1">类型</th>
	                                       <th data-field="sisactive" data-formatter="sisactiveFormatter" class="col-sm-1">状态</th>
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
      <div class="modal inmodal" id="modal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content animated bounce">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h5 class="modal-title">添加测评计划</h5>
                  </div>
                  <!--Start 表单 -->
                    <form class="form-horizontal m-t" id="statisticForm" action="${basePath}/eval/statistic/addStatistic">
	                 <div class="modal-body">
		        	  	 <div class="ibox-content">
				            	 <input id="sid" name="statistic.sid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">名称：</label>
					                   <div class="col-sm-8">
					                       <input id="sname" name="statistic.sname"  minlength="2" type="text" class="form-control" required="" aria-required="true">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">开始时间：</label>
					                   <div class="col-sm-8">
                                            <input readonly placeholder="开始日期" class="form-control layer-date" id="stime" name="statistic.stime" required="" aria-required="true">
                                             <label class="laydate-icon inline demoicon" id="sicon"></label>
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">结束时间：</label>
					                   <div class="col-sm-8">
					                      <input readonly placeholder="结束日期" class="form-control layer-date" id="etime" name="statistic.etime" required="" aria-required="true">
					                      <label class="laydate-icon inline demoicon" id="eicon"></label>
					                   </div>
					               </div>
					                 <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                       <select id="stype" name="statistic.stype" class="form-control m-b"  required="" aria-required="true" >
					                       		   <option value="">请选择统计类型</option>
					                       		  <option value="0">年度统计</option>
					                       		  <option value="1">季度统计</option>
					                       		  <option value="2">单月统计</option>
					                       		  <option value="3">其他统计</option>
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
    <script src="${basePath }/js/plugins/layer/laydate/laydate.js"></script>
    <script type="text/javascript">
    
	var $table = $("#table");
	var $remove = $("#batchRemove");
    var action = "${basePath}/eval/statistic/addStatistic";
    var text = "添加成功!";
    
  	//表格其他属性  行变色data-row-style="rowStyle" 高度data-height="485"
  	//自定义数据参数
    function queryParams(params) {
    	//params.ni = "ni"; //自定义参数
        //console.log(JSON.stringify(params));
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/statistic/getStatisticList"});
    }
    function getRandom(n){
        return Math.floor(Math.random()*n+1)
    }

    //日期范围限制
    var start = {
        elem: '#stime',
        format: 'YYYY-MM-DD hh:mm:ss',
        min: laydate.now(), //设定最小日期为当前日期
        max: '2099-06-16', //最大日期
        istime: true,
        istoday: false,
        choose: function (datas) {
            end.min = datas; //开始日选好后，重置结束日的最小日期
            end.start = datas //将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem: '#etime',
        format: 'YYYY-MM-DD hh:mm:ss',
        min: laydate.now(),
        max: '2099-06-16',
        istime: true,
        istoday: false,
        choose: function (datas) {
            start.max = datas; //结束日选好后，重置开始日的最大日期
        }
    };
   
    window.operateEvents = {
	    		 'click .edit': function (e, value, row) {
	    			 	//console.log(JSON.stringify(row));
	    	            $(".modal-title").text("修改测评计划");
	    	        	$("#sid").val(row.sid);
	    	        	$("#sname").val(row.sname);
	    	        	$("#stime").val(row.stime);
	    	    		$("#etime").val(row.etime);
	    	    		$("#stype").val(row.stype);
	    	    		action = "${basePath}/eval/statistic/editStatistic";
	    	    		text = "修改成功!";
	    	      }, 
	    	      'click .update': function (e, value, row) {
	    			 	var text = "启用当前测评计划成功!";
	    			 	var sisactive = row.sisactive;
	    			 	if(sisactive==1){
	    			 		text = "停用当前测评计划成功!";
	    			 		sisactive = 0;
	    			 	}else{
	    			 		sisactive = 1;
	    			 	}
	    				swal({
	    	                title: "修改测评计划状态",
	    	                text: "确认启用或停用当前测评计划",
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
	     		     			url: "${basePath}/eval/statistic/updateStatistic",	
	     		     			data: {sid: row.sid,sisactive: sisactive},	
	     		     			async: false,
	     		     			success: function(data) {
	     		     				swal({title:"测评计划状态",text:text,timer:2000, type: "success"});
	     		     				refresh();
	     		     			},
	     		     			error: function(request) {
	     		     			}
	     		    		});
	    	            });
	    	      },
    	         'click .remove': function (e, value, row) {
    	        	swal({
    	                title: "删除当前测评计划",
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
     		     			url: "${basePath}/eval/statistic/removeStatistic",	
     		     			data: {sid: row.sid},	
     		     			async: false,
     		     			success: function(data) {
     		     				swal({title:"测评计划",text:"删除成功!",timer:2000, type: "success"});
     		     				refresh();
     		     			},
     		     			error: function(request) {
     		     			}
     		    		});
    	            });
    	        }
        };

	    function stypeFormatter(value, row, index) {
	   	 var str = "";
	   	 if(row.stype==0){
	   		 str = "年度统计";
	   	 }else if(row.stype==1){
	   		 str = "季度统计";
	   	 }else if(row.stype==2){
	   		 str = "单月统计";
	   	 }else{
	   		str = "其他统计";
	   	 }
	       return [ str ].join('');
	   }
	    function sisactiveFormatter(value, row, index) {
	    	 var str = "";
        	 if(row.sisactive==0){
        		 str = "已停用";
        	 }else{
        		 str = "已启用";
        	 }
            return [ str ].join('');
		   }
        function operateFormatter(value, row, index) {
        	var text = row.sisactive==1?"停用":"启用";
        	var color = row.sisactive==1?"btn-danger":"btn-success"; 
            return [
                '<div >',
                '<button type="button" class="btn update '+color+' btn-sm btn-outline ">',
                '<i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;'+text+'</button>',
                '<button type="button" class="btn edit btn-primary btn-sm btn-outline" ',
                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
                '<button type="button" class="btn remove btn-primary btn-sm btn-outline">',
                '<i class="glyphicon glyphicon-remove"></i>&nbsp;&nbsp;删除</button>',
                '</div>'
            ].join('');
        }
    
    $(function(){
    	
    	 $("#sicon").click(function(){laydate(start);});
    	 $("#eicon").click(function(){laydate(end);});
    	    
    	 $table.on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
             $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);
         })
    	 $remove.click(function () {
             var sids = $.map($table.bootstrapTable('getSelections'), function (row) {
                 return row.sid;
             });
            
             swal({
	                title: "批量删除测评计划",
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
		     			url: "${basePath}/eval/statistic/batchRemoveStatistic",	
		     			data: {sids: sids.toString()},	
		     			async: false,
		     			success: function(data) {
		     				swal({title:"测评计划",text:"批量删除成功!",timer:2000, type: "success"});
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
    		$(".modal-title").text("添加测评计划");
    		$("#sid").val("");
        	$("#sname").val("");
        	$("#stime").val("");
    		$("#etime").val("");
    		$("#stype").val("");
    		action = "${basePath}/eval/statistic/addStatistic";
    		text = "添加成功!";
    	});
    	$("#statisticForm").validate({
   		    submitHandler: function() {
	   		    $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: action,	
	     			data: $("#statisticForm").serialize(),	
	     			async: false,
	     			success: function(data) {
	     				$("#close").click();
	     				swal({title:"测评计划",text:text,timer:2000, type: "success"});
	     			},
	     			error: function(XMLHttpRequest, textStatus, errorThrown) {
	     				//alert(XMLHttpRequest.status);
                        //alert(XMLHttpRequest.readyState);
                        //alert(textStatus);
	     			}
	    		});
   		    }
    	});
    });
    
    </script>
</body>
</html>