package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.DepartmentOption;

public class DepartmentOptionController extends Controller {

	public void index(){
		this.render("departmentOption.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getDepartmentOptionList(){
		String dqid = getPara("dqid");
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_department_option do where do.dqid="+dqid;
		}else{
			sqlExpectSelect = "from t_department_option do where do.dqid="+dqid+" and do.doname like '%"+search+"%'";
		}
		
		//分页查
		Page<DepartmentOption> departmentOptionPage = DepartmentOption.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select do.*",
				sqlExpectSelect);
		int total = departmentOptionPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentOptionPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addDepartmentOption(){
		DepartmentOption departmentOption = getModel(DepartmentOption.class);
		departmentOption.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateDepartmentOption(){
		DepartmentOption departmentOption = getModel(DepartmentOption.class);
		departmentOption.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeDepartmentOption(){
		int doid = getParaToInt("doid");
		DepartmentOption.dao.deleteById(doid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveDepartmentOption(){
		String[] doidStrArr = getPara("doids").split(",");
		for(String doid : doidStrArr){
			DepartmentOption.dao.deleteById(doid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
}
