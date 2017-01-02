package com.tao.www.controller;


import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeToDepartment;

public class DepmDistributeController extends Controller {

	public void index(){
		this.render("depmDistribute.jsp");
	}
	
	public void getDempDistributeList(){
		String search = getPara("search");
		StringBuffer sb = new StringBuffer();
		sb.append("from t_employee e ")
		  .append("LEFT JOIN t_employee_department ed on e.eid=ed.eid ") 
		  .append("LEFT JOIN t_department d on ed.did=d.did ") 
		  .append("LEFT JOIN t_employee_role er on er.eid=e.eid ") 
		  .append("LEFT JOIN t_role r on er.rid=r.rid ") 
		  .append("WHERE r.rname like '%直%属%副%总%经%理%' ");
		if(search!=null&&!"".equals(search)){
			sb.append(" and e.zname like '%"+search+"%'");	
		}
		 sb.append(" GROUP BY e.eid ");
		//分页查
		Page<Employee> employeePage = Employee.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"SELECT e.eid,e.zname,r.rid,r.rname,group_concat(d.dname) dnames ",
				sb.toString());
		int total = employeePage.getTotalRow();
		StringBuffer sb2 = new StringBuffer();
		sb2.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
		this.renderJson(sb2.toString());
	}
	
	public void addDepmDistribute(){
		String didStr = getPara("dids");
		String[] didStrArr = new String[0];
		if(didStr!=null&&!"".equals(didStr)){
			didStrArr = getPara("dids").split(",");
		}
		int eid = getParaToInt("eid")==null?0:getParaToInt("eid");
		int rid = getParaToInt("rid")==null?0:getParaToInt("rid");
		//删除之前的存在部门
		Db.update("delete from t_employee_department where eid ="+eid);
		//更新eid管辖部门
		EmployeeToDepartment etd = null;
		for(String did : didStrArr){
			etd = new EmployeeToDepartment();
			etd.set("did", Integer.valueOf(did));
			etd.set("eid", eid);
			etd.set("rid", rid);
			etd.save();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
