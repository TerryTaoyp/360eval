package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeToEmployee;

public class EvalDistributeController extends Controller {
	
	public void index(){
		this.render("evalDistribute.jsp");
	}
	
	public void getEvalDistributeList(){
		String search = getPara("search");
		StringBuffer sb = new StringBuffer();
		sb.append("from t_employee e  ")
		  .append("LEFT JOIN t_employee_employee ee on e.eid=ee.eid ") 
		  .append("LEFT JOIN t_employee te on te.eid=ee.eeid ") 
		  .append("LEFT JOIN t_employee_role er on er.eid=e.eid ") 
		  .append("LEFT JOIN t_role r on er.rid=r.rid ") 
		  .append("WHERE (r.rname like '%直%属%副%总%经%理%' or r.rname like '%部%门%经%理%' or r.rname like '%普%通%员%工%')");
		if(search!=null&&!"".equals(search)){
			sb.append(" and e.zname like '%"+search+"%'");	
		}
		 sb.append(" GROUP BY e.eid order by r.rid");
		//分页查
		Page<Employee> employeePage = Employee.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"SELECT e.eid,e.zname,r.rid,r.rname,group_concat(te.zname) znames ",
				sb.toString());
		int total = employeePage.getTotalRow();
		StringBuffer sb2 = new StringBuffer();
		sb2.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
		this.renderJson(sb2.toString());
	}
	
	public void addEvalDistribute(){
		String eeidStr = getPara("eeids");
		String[] eeidStrArr = new String[0];
		if(eeidStr!=null&&!"".equals(eeidStr)){
			eeidStrArr = getPara("eeids").split(",");
		}
		int eid = getParaToInt("eid")==null?0:getParaToInt("eid");
		int rid = getParaToInt("rid")==null?0:getParaToInt("rid");
		//删除之前的存在测评分配
		Db.update("delete from t_employee_employee where eid ="+eid);
		//更新eid测评分配
		EmployeeToEmployee ete = null;
		for(String eeid : eeidStrArr){
			ete = new EmployeeToEmployee();
			ete.set("eeid", Integer.valueOf(eeid));
			ete.set("eid", eid);
			ete.set("rid", rid);
			ete.save();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
