package com.tao.www.controller;

import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.DepartmentType;

public class DepartmentTypeController extends Controller {

	public void index(){
		this.render("departmentType.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getDepartmentTypeList(){
		/*String userName = this.getPara("userName");
		String sayHello = "Hello " + userName + ", welcome to JFinal world.";
		this.setAttr("sayHello", sayHello);
		this.render("/hello.jsp");*/
		//System.out.println(getPara("ni"));
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_department_type";
		}else{
			sqlExpectSelect = "from t_department_type where dtname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<DepartmentType> departmentTypePage = DepartmentType.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select *",
				sqlExpectSelect);
		//System.out.println("第几页:"+(getParaToInt("offset", 0)/getParaToInt("limit", 10)+1)+"===每页条数:"+getParaToInt("limit", 10));
		int total = departmentTypePage.getTotalRow();
		//DepartmentType.dao.paginate(page, 15, "select *", "from item where" + sqlCondition + " order by id desc"))
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentTypePage.getList())+"}");
		this.renderJson(sb.toString());
		
		//setAttr("departmentTypePage", departmentTypePage);
		//String json = "  [{ \"id\": 0,\"name\": \"测试0\", \"price\": \"&yen;0\"}]  ";
		//this.renderJson(json);
		//setAttr("departmentTypeList", departmentTypeList);
	}
	
	
	public void addDeparmentType(){
		DepartmentType departmentType = getModel(DepartmentType.class);
		//System.out.println(departmentType.getStr("name"));
		departmentType.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateDeparmentType(){
		DepartmentType departmentType = getModel(DepartmentType.class);
		//System.out.println(departmentType.getStr("name"));
		departmentType.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeDeparmentType(){
		int dtid = getParaToInt("dtid");
		//System.out.println(departmentType.getStr("name"));
		DepartmentType.dao.deleteById(dtid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveDeparmentType(){
		String[] dtidStrArr = getPara("dtids").split(",");
		for(String dtid : dtidStrArr){
			DepartmentType.dao.deleteById(dtid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getDepartmentTypeTree(){
		
		/*
		  String zNodes ="["+
						"{ \"id\":\"0\", \"pId\":\"-1\", \"name\":\"所有部门类型\", \"iconOpen\":\"css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"css/zTreeStyle/img/diy/1_close.png\", \"open\":\"false\"},"+
						"{ \"id\":\"1\", \"pId\":\"0\", \"name\":\"风险型部门\"},"+
						"{ \"id\":\"2\", \"pId\":\"0\", \"name\":\"责任型部门\"},"+
						"{ \"id\":\"3\", \"pId\":\"0\", \"name\":\"贡献型部门\"}"+
					  "]";
		
		 */
		String dataType = getPara("dataType")==null?"":getPara("dataType");
		String sqlExpectSelect = null;
		if(dataType.equals("1")){
			sqlExpectSelect = "select dtid,dtname from t_department_type where dtname not like '%高%管%'";
		}else{
			sqlExpectSelect = "select dtid,dtname from t_department_type";
		}
		
		List<DepartmentType> departmentTypeList = DepartmentType.dao.find(sqlExpectSelect);
		StringBuffer sb = new StringBuffer();
		sb.append("[ ");
		sb.append("{ \"id\":\"0\", \"pId\":\"-1\", \"name\":\"所有类型\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"true\"},");
		int index = 0;
		for(DepartmentType dt :departmentTypeList){
			
			sb.append("{ \"id\":\""+dt.getLong("dtid")+"\",");
			sb.append("\"pId\":\"0\",");
			sb.append("\"name\":\""+dt.getStr("dtname")+"\"}");
			if(index<departmentTypeList.size()-1){
				sb.append(",");
			}
			index++;
			
		}
		sb.append("]");
		this.renderJson(sb.toString());
	}
}
