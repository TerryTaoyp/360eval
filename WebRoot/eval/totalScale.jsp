<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>总计比重管理</title>
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
	                        <h2>总计比重管理</h2>
	                    </div>
	                    <div class="ibox-content">
							<div class="btn-group hidden-xs" id="tableToolbar" role="group">
	                         </div>
	                              <table 
	                              	id="table" 
	                              	data-toggle="table" 
	                              	data-url="${basePath}/eval/totalScale/getTotalScaleList" 
	                              	data-query-params="queryParams"
	                              >
					            <thead>
						            <tr>
						                <th data-field="state" data-checkbox="true" class="col-sm-1"></th>
						                <th data-field="tsid" class="col-sm-1">编号</th>
						                <th data-field="tstype" class="col-sm-2">类型</th>
	                                       <th data-field="tsname" class="col-sm-3">对象</th>
	                                       <th data-field="tsscale" class="col-sm-2">比重(%)</th>
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
                      <h5 class="modal-title">修改总计比重</h5>
                  </div>
                  	<!--Start 表单 -->
                <form class="form-horizontal m-t" id="totalScaleForm" action="${basePath}/eval/totalScale/updateTotalScale">
                  <div class="modal-body">
			        	  	 <div class="ibox-content">
					           	 <input id="tsid" name="totalScale.tsid"  type="hidden"/>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">对象：</label>
					                   <div class="col-sm-8">
					                       <input id="tsname" name="totalScale.tsname"  minlength="1" type="text" class="form-control" required="" aria-required="true" readonly="readonly">
					                   </div>
					               </div>
					               <div class="form-group">
					                   <label class="col-sm-3 control-label">类型：</label>
					                   <div class="col-sm-8">
					                     <input id="tstype" name="totalScale.tstype"  minlength="1" type="text" class="form-control" required="" aria-required="true" readonly="readonly">
					                   </div>
					               </div>
					                 <div class="form-group">
					                   <label class="col-sm-3 control-label">比重(%)：</label>
					                   <div class="col-sm-8">
					                       <input id="tsscale" name="totalScale.tsscale" minlength="1" maxlength="3" lonum="0" upnum="100" placeholder="请输入0~100数字"  type="text" class="form-control" required="" aria-required="true"/>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
  	//表格其他属性  行变色data-row-style="rowStyle" 高度data-height="485"
  	//自定义数据参数
    function queryParams(params) {
    	//params.ni = "ni"; //自定义参数
        //console.log(JSON.stringify(params));
    	return params;
    }
    function refresh(){
    	$("#table").bootstrapTable('refresh',{url: "${basePath}/eval/totalScale/getTotalScaleList"});
    }
    
    var lonum = 0;
    var upnum = 100;
    function getRemainNum(tstype,tsid){
    	$.ajax({
 			cache: false,
 			type: "POST",
 			url: "${basePath}/eval/totalScale/getRemainNum",	
 			data: {'tstype': tstype,'tsid': tsid},	
 			async: false,
 			success: function(data) {
 				var $tsscale = $("#tsscale");
 				$tsscale.attr("upnum",data.remainNum);
 				 lonum = $tsscale.attr("lonum");
 				 upnum = $tsscale.attr("upnum");
 				if(upnum==lonum){
 					$tsscale.attr("placeholder","当前剩余比重为0(分)");
 				}else{
 					$tsscale.attr("placeholder","请输入"+lonum+"~"+upnum+"内数字");
 				}
 			},
 			error: function(request) {
 			}
		});
    }
    window.operateEvents = {
	    		 'click .edit': function (e, value, row) {
	    	        	$("#tsid").val(row.tsid);
	    	        	$("#tsname").val(row.tsname);
	    	    		$("#tstype").val(row.tstype);
	    	    		$("#tsscale").val(row.tsscale);
	    	    		getRemainNum(row.tstype,row.tsid);
	    	      }
        };
        function operateFormatter(value, row, index) {
            return [
                '<div >',
                '<button type="button" class="btn edit btn-primary btn-sm btn-outline " ',
                'data-toggle="modal" data-target="#modal"><i class="glyphicon  glyphicon-edit"></i>&nbsp;&nbsp;修改</button>',
                '</div>'
            ].join('');
        }
    
    $(function(){
    	
    	$("#tsscale").on('change',function(e){
        	var val =$(this).val() ;
        	if(!isNaN(val)){
        		if(parseInt(val) > parseInt(upnum)){
            		$(this).val(upnum);
            	}else if(parseInt(val) <parseInt(lonum)){
            		$(this).val(lonum);
            	}
        	}else{
        		$(this).val(lonum);
        	}
         });
    	
    	$("#close").click(function(){
    		refresh();
    	});
    	
    	$("#totalScaleForm").validate({
   		    submitHandler: function() {
	   		    $.ajax({
	     			cache: false,
	     			type: "POST",
	     			url: "${basePath}/eval/totalScale/updateTotalScale",	
	     			data: $("#totalScaleForm").serialize(),	
	     			async: false,
	     			success: function(data) {
	     				$("#close").click();
	     				swal({title:"总计比重",text:"修改成功",timer:2000, type: "success"});
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