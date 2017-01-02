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
	                    <div class="ibox-content">
	                    	<form class="form-horizontal m-t" id="satisfyTestForm" action="${basePath }/result/satisfyResult/addSatisfyResult" method="post">
	                             	
	                              <div id="vertical-timeline" class="vertical-container dark-timeline">
	                               <c:choose>
		                              	<c:when test="${size==0 }">
		                              		<p class="text-center">暂无测评题目</p>
		                              	</c:when>
		                                <c:otherwise>
			                                  <c:forEach items="${satisfyQuestionList }" var="sq" varStatus="statusQ">
			                                  		<input type="hidden" name="sqids" value="${sq.sqid }" />
			                                  		<input type="hidden" name="sqtypes" value="${sq.sqtype }" />
			                                  		<c:choose>
			                                  			<c:when test="${sq.sqtype==1 }">
			                                  				<div class="vertical-timeline-block">
						                                        <div class="vertical-timeline-icon navy-bg">
						                                        	 <span>${statusQ.index+1 }</span> 
						                                        </div>
						                                        <div class="vertical-timeline-content">
						                                          <h3>${sq.sqname }?</h3> 
						                                            <p>&nbsp;</p>
						                                          <textarea name="srdname${sq.sqid }"  
						                                          class="form-control" required="" aria-required="true"></textarea>
						                                        </div>
						                                    </div>
			                                  			</c:when>
			                                  			<c:otherwise>
						                                  		<div class="vertical-timeline-block">
							                                        <div class="vertical-timeline-icon navy-bg">
							                                        	<span>${statusQ.index+1 }</span> 
							                                        </div>
							                                        <div class="vertical-timeline-content">
							                                          <h3>${sq.sqname }?</h3> 
							                                          <p>&nbsp;</p>
						                                        	 <c:forEach items="${gradeList }" var="g"  varStatus="statusG">
							                                        	<label class="i-checks"><input type="radio" name="srdweight${sq.sqid }"  class="form-control" required="" aria-required="true" value="${g.gnum }" >
							                                        		<span >(${g.gnum }分)</span>
							                                        	</label>&nbsp;&nbsp;&nbsp;&nbsp;
					                                        		</c:forEach>
							                                        </div>
							                                    </div>
			                                  			</c:otherwise>
			                                  		</c:choose>
			                                  </c:forEach>
	                                    </c:otherwise>
		                              </c:choose>
				                  </div>
				                  			<div class="form-group">
							                   <div class="col-sm-4 col-sm-offset-5">
							                       <input type="reset" id="reset" class="btn" name="重置"/>&nbsp;&nbsp;&nbsp;&nbsp;
			                       					<button class="btn btn-primary"id="submit" type="submit">确认</button>
							                   </div>
							                 </div>
			                  </form>
				         </div>
	                  </div>
	            </div>
	      </div>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script src="${basePath }/js/plugins/iCheck/icheck.min.js"></script>
    <script type="text/javascript">
    
	    $(document).ready(function () {
	        $('.i-checks').iCheck({
	            checkboxClass: 'icheckbox_square-green',
	            radioClass: 'iradio_square-green',
	        });
	        $("#reset").click(function(){
	        	$('input:radio').iCheck('uncheck');
	        });
	        $("#satisfyTestForm").validate({
	        	errorPlacement: function(error, element) {  
	        		   if ( element.is(":radio") ) {
	        			   var reg=new RegExp('必填');
	        			   var flag = reg.test(element.parents(".vertical-timeline-content").text().trim());
	        			   if(!flag)
	        				   element.parents(".vertical-timeline-content").append("<p>"+error.html()+"</p>");
	        		   } else  
	        		        error.appendTo( element.parent() );  
	        		},  
	   		    submitHandler: function() {
		   		    $.ajax({
		     			cache: false,
		     			type: "POST",
		     			url: "${basePath }/result/satisfyResult/addSatisfyResult",	
		     			data: $("#satisfyTestForm").serialize(),	
		     			async: false,
		     			success: function(data) {
		     				swal({
		     					title:"满意度测评",text:"测评完成!",
		     					timer:2000,type: "success",
		    	            }, function () {
		    	            	 window.parent.refresh();//刷新父页面表格
		    	            	//当你在iframe页面关闭自身时
		    	            	var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
		    	            	parent.layer.close(index); //再执行关闭     
		    	            	                
		     		    	});
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