<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div style="color:red;font-size:20px;">${nameMsg }==${department.getDepartmentType()['name'] }==${department.departmentType.name }</div>
	<form action="${basePath}/hello" method="post">
		请输入您的名字：
		<input type="text" name="userName" value="${userName }" />
		<input type="submit" value="确定"/>
	</form>
	
	<div class="table_box">
				<table class="list" border='1'>
					<tbody>
						<tr>
							<th width="5%">编号</th>
							<th width="25%">名称</th>
							<th width="25%">描述</th>
							<th width="45%">操作</th>
						</tr>
							<c:forEach items="${departmentTypeList }" var="dt">
								<tr>
									<td style="text-align: left;">
										${dt.dtid }
									</td>
									<td style="text-align: left;">${dt.name }</td>
									<td style="text-align: left;">${dt.describe }</td>
									<td style="text-align: left;">
										<c:if test="${!empty dt.getDepartmentList()}">
											${dt.getDepartmentList().get(0).did }==${dt.getDepartmentList().get(0).name }
										</c:if>
									</td>
				 				</tr>
							</c:forEach>
					</tbody>
				</table>
				
			</div>
</body>
</html>