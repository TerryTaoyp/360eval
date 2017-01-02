package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.EmployeeOption;

public class EmployeeOptionController extends Controller {

	public void index(){
		this.render("employeeOption.jsp");
	}
	
	public void getEmployeeOptionList(){
		String eqsid = getPara("eqsid");
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_employee_option eo where eo.eqsid="+eqsid;
		}else{
			sqlExpectSelect = "from t_employee_option eo where eo.eqsid="+eqsid+" and eo.eoname like '%"+search+"%'";
		}
		
		//分页查
		Page<EmployeeOption> employeeOptionPage = EmployeeOption.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select eo.*",
				sqlExpectSelect);
		int total = employeeOptionPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeeOptionPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addEmployeeOption(){
		EmployeeOption employeeOption = getModel(EmployeeOption.class);
		employeeOption.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateEmployeeOption(){
		EmployeeOption employeeOption = getModel(EmployeeOption.class);
		employeeOption.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeEmployeeOption(){
		int eoid = getParaToInt("eoid");
		EmployeeOption.dao.deleteById(eoid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveEmployeeOption(){
		String[] eoidStrArr = getPara("eoids").split(",");
		for(String eoid : eoidStrArr){
			EmployeeOption.dao.deleteById(eoid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
}
