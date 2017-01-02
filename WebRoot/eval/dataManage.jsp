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
    <link href="${basePath }/css/plugins/iCheck/custom.css" rel="stylesheet">
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
	                        <h2>测评数据管理</h2>
	                    </div>
	                    <div class="ibox-content">
	                    	     	<!--Start 表单 -->
					                <form class="form-horizontal m-t" id="typeForm" action="${basePath }/eval/statistic/dataManage" target="_self">
										               <div class="form-group">
										                <label class="col-sm-1 control-label">测评计划：</label>
										                   <div class="col-sm-3">
										                       <select id="sid" name="sid" class="form-control "  required="" aria-required="true" >
										                       		  <option value="">请选择测评计划</option>
										                       		  <c:forEach items="${statisticList }" var="st">
										                       		  		<option <c:if test="${sid ==st.sid }"> selected="selected" </c:if>
										                       		  		  value="${st.sid }">${st.sname }</option>
										                       		  </c:forEach>
							                                    </select>
										                   </div>
										                    <label class="col-sm-1 control-label">测评类型：</label>
										                   <div class="col-sm-3">
										                       <select id="type" name="type" class="form-control "  required="" aria-required="true" >
										                       		  <option value="">请选择测评类型</option>
										                       		  <c:forEach items="${typeList }" var="s" varStatus="vs">
										                       		  		<option value="${vs.index+1 }"  
										                       		  			<c:if test="${type ==(vs.index+1) }"> selected="selected" </c:if>
										                       		  		>${s }</option>
										                       		  </c:forEach>
							                                    </select>
										                   </div>
										               </div>
										                <div class="form-group">
										                 <label class="col-sm-1 control-label">参评人：</label>
										                   <div class="col-sm-3">
							                                    <input id="name" name="name" value="${name }" type="text" minlength="1" placeholder="请输入参评人姓名" class="form-control" required="" aria-required="true">
							                                </div>
							                                <div class="col-sm-3 col-sm-offset-2">
			                       					  		 	<input type="submit"  class="btn btn-primary" value="查询"/>
			                       					  		 </div>
										               </div>
					                  </form>
					                  <!-- End 表单 -->
					                  <table class="table table-bordered">
	                            <thead>
	                                <tr>
	                                    <th class="col-sm-4">测评计划</th>
	                                    <th class="col-sm-2">测评类型</th>
	                                    <th class="col-sm-2">测评对象</th>
	                                    <!--  <th class="col-sm-2">测评分数</th>-->
	                                    <th class="col-sm-2">操作</th>
	                                </tr>
	                            </thead>
	                            <tbody class="text-center">
	                            	<c:choose>
	                            		<c:when test="${size==0 }">
	                            			<tr><td colspan="5">没有数据</td></tr>
	                            		</c:when>
	                            		<c:otherwise>
			                            	<c:forEach items="${rList }" var="r">
				                                <tr>
				                                    <td>${r.eval }</td>
				                                    <td>${r.type }</td>
				                                    <td>${r.obj }</td>
				                                    <!--  <td>${r.total }</td>-->
				                                    <td>
				                                    <button href="#" onclick="remove(${r.typeParam },${r.id })"
				                                    		class="btn btn-outline btn-primary">
				                                    <i class="glyphicon glyphicon-remove"></i>&nbsp;删除测评数据</button></td>
				                                </tr>
			                                </c:forEach>
	                            		</c:otherwise>
	                            	</c:choose>
	                            </tbody>
                       		 </table>
	                    </div>
	                </div>
	            </div>
	    </div>
	     <!--End 当前表格开始 -->
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
	<script src="${basePath }/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${basePath }/js/plugins/validate/messages_zh.min.js"></script>
    <script src="${basePath }/js/demo/form-validate-demo.js"></script>
    <script src="${basePath }/js/plugins/layer/layer.min.js"></script>
    <script src="${basePath }/js/plugins/iCheck/icheck.min.js"></script>
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
    function remove(type,id){
          	 $.ajax({
        			cache: false,
        			type: "POST",
        			url: "${basePath}/eval/statistic/remove",	
        			data: {type:type,id:id},	
        			async: false,
        			success: function(data) {
        				swal({title:"测评数据",text:"删除成功!",timer:2000, type: "success"},
        				function(){
        					location.reload();
        				});
        				
        			},
        			error: function(request) {
        			}
       		});
    }
    
    $(document).ready(function () {
    	
	    $('.i-checks').iCheck({
	        checkboxClass: 'icheckbox_square-green',
	        radioClass: 'iradio_square-green',
	    });
	    $("#reset").click(function(){
	    	$('input:radio').iCheck('uncheck');
	    });
	    
	     $("#typeForm").validate({
	        	errorPlacement: function(error, element) {  
	        		   if ( element.is(":radio") ) {
	        			   var reg=new RegExp('必填');
	        			   var flag = reg.test(element.parents("div .col-sm-3").text().trim());
	        			   if(!flag)
	        				   element.parents("div .col-sm-3").append("<p>"+error.html()+"</p>");
	        		   } else  
	        		        error.appendTo( element.parent() );  
	        		},  
	   		    submitHandler: function() {
	   		    	var form = $("#typeForm").get(0);
	   		    	form.submit();
	   		    }
	    	});
    });
    </script>
</body>
</html>