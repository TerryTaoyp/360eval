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
    <link href="${basePath }/css/large-table.css" rel="stylesheet">
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
	                        <h2>满意度测评结果</h2>
	                    </div>
	                    <div class="ibox-content">
	                     <div class="tabs-container">
                    <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">封闭题</a>
                        </li>
                        <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">开放题</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
	                            <div style="height: 55px;line-height: 55px;">
										<button type="button" class="btn btn-outline btn-primary" onclick="javascript:history.go(-1);" >
			                            	<i class="fa fa-reply"></i>&nbsp;返回
			                          	</button>
			                          	<a href="${basePath}/result/resultType/exportSCResult?sid=${sid}" class="btn btn-outline btn-primary"><i class="glyphicon glyphicon-export"></i>&nbsp;导出封闭题结果</a>
		                       </div>
							   <div class="table-responsive">
								<table class="table table-bordered text-center ">
									<thead>
									<tr>
										<th rowspan="2" width="150">内容</th>
										<c:forEach items="${srCloseDp }" var="dp">
											<th colspan="2">${dp.key }</th>
										</c:forEach>
									</tr>
									<tr>
										<c:forEach  begin="1" end="${dpSize }" step="1">
											<th >均值</th>
											<th >方差</th>
									    </c:forEach>
									</tr>
									</thead>
									<tbody>
									<c:forEach items="${srCloseMap }" var="srCloseList">
										<tr>
											<td>${srCloseList.key }</td>
											<c:forEach items="${srCloseList.value }" var="num">
												<td>${num }</td>
											</c:forEach>
										</tr>
									</c:forEach>
									</tbody>
						        </table>
						    </div>
                        </div>
                        <div id="tab-2" class="tab-pane">
                        	<div style="height: 55px;line-height: 55px;">
										<button type="button" class="btn btn-outline btn-primary" onclick="javascript:history.go(-1);" >
			                            	<i class="fa fa-reply"></i>&nbsp;返回
			                          	</button>
			                          	<a href="${basePath}/result/resultType/exportSOResult?sid=${sid}" class="btn btn-outline btn-primary"><i class="glyphicon glyphicon-export"></i>&nbsp;导出开放题结果</a>
		                     </div>
               				<div class="list-group">
               					<c:choose>
               						<c:when test="${openSize==0 }">
               							 <p class="text-center">暂无数据</p>
               						</c:when>
               						<c:otherwise>
		               					 <c:forEach items="${srOpenMap }" var="srOpenList">
		               					 	 <div class="list-group-item">
				                                <h3 class="list-group-item-heading">${srOpenList.key }</h3>
												<ol>
													<c:forEach items="${srOpenList.value }" var="str">
														<li class="list-group-item-text">${str }</li>
													</c:forEach>
				                            	</ol>
				                            </div>
               							 </c:forEach>	
               						</c:otherwise>
               					</c:choose>
                        	</div>
                        </div>
                    </div>
                </div>
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
       <!-- Sweet alert -->
    <script src="${basePath }/js/plugins/sweetalert/sweetalert.min.js"></script>
    <script type="text/javascript">
    
    </script>
</body>
</html>