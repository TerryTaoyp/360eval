package com.tao.www.controller;


import java.util.List;

import com.jfinal.aop.Clear;
import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.interceptor.LoginInterceptor;
import com.tao.www.model.Department;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeToEmployee;
import com.tao.www.model.EmployeeToRole;

public class EmployeeController extends Controller {

	public void index(){
		List<Department> departmentList = Department.dao.find("select * from t_department");
		setAttr("departmentList", departmentList);
		this.render("employee.jsp");
	}
	
	public void getEmployeeList(){
		String search = getPara("search");
		int did = getParaToInt("did");
		int dtid = getParaToInt("dtid");
		String strDid = "";
		if(did!=0){
			strDid = " and e.did="+did;
		}
		String strDtid = "";
		if(dtid!=0){
			strDtid = " and d.dtid="+dtid;
		}
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_employee e "
					+ "left join t_department d on e.did=d.did "
					+ "left join t_employee_role er on er.eid=e.eid "
					+ "left join t_role r on er.rid=r.rid "
					+ "where 1=1" +strDid +strDtid 
					+ " GROUP BY e.eid";
		}else{
			sqlExpectSelect ="from t_employee e "
					+ "left join t_department d on e.did=d.did "
					+ "left join t_employee_role er on er.eid=e.eid "
					+ "left join t_role r on er.rid=r.rid "  
					+ "where 1=1 and e.zname like '%"+search+"%'"+strDid + strDtid
					+ " GROUP BY e.eid";
		}
		//分页查
		System.out.println(getParaToInt("offset", 0));
		Page<Employee> employeePage = Employee.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select e.*,d.dname,group_concat(r.rname) rnames",
				sqlExpectSelect);
		int total = employeePage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
		this.renderJson(sb.toString());
		
	}
	
	
	public void addEmployee(){
		Employee employee = getModel(Employee.class);
		employee.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updatePwd(){
		Employee employee = getModel(Employee.class);
		String cpwd = getPara("cpwd");
		if(!employee.getStr("pwd").equals(cpwd)){
			this.renderJson("{\"message\":\"两次密码不一致!\"}");
		}else{
			employee.update();
			this.renderJson("{\"message\":\"success\"}");
		}
	}
	
	public void updateEmployee(){
		int eid = getParaToInt("eid");
		int isactive = getParaToInt("isactive");
		//修改当前状态
		Employee.dao.findById(eid).set("isactive", isactive).update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void editEmployee(){
		Employee employee = getModel(Employee.class);
		employee.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void resetEmployee(){
		int eid = getParaToInt("eid");
		//初始密码000000
		Employee.dao.findById(eid).set("pwd", "000000").update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeEmployee(){
		int eid = getParaToInt("eid");
		Employee.dao.deleteById(eid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveEmployee(){
		String[] eidStrArr = getPara("eids").split(",");
		for(String eid : eidStrArr){
			Employee.dao.deleteById(eid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	@Clear(LoginInterceptor.class)
	public void newEm(){
		Employee employee = getModel(Employee.class);
		String cp = getPara("confirm_password");
		if(cp!=null&&cp.equals(employee.get("pwd"))){
			Employee oldEm = Employee.dao.findFirst("select * from t_employee where card='"+employee.getStr("card").trim()
					+"' or ename='"+employee.getStr("ename").trim()+"'");
			if(oldEm!=null){
				this.renderJson("{\"message\":\"身份证或登录名已经存在!\"}");
			}else{
				employee.save();
				this.renderJson("{\"message\":\"success\"}");
			}
		}else{
			this.renderJson("{\"message\":\"两次密码不一致!\"}");
		}
	}
	
	public void distriRole(){
		String ridStr = getPara("rids");
		String[] ridStrArr = new String[0];
		if(ridStr!=null&&!"".equals(ridStr)){
			ridStrArr = getPara("rids").split(",");
		}
		int eid = getParaToInt("eid")==null?0:getParaToInt("eid");
		//根据rid查询之前存在的角色并删除
		List<EmployeeToRole> empToRoleList = EmployeeToRole.dao.find("select eid,rid from t_employee_role where eid="+eid);
		if(empToRoleList!=null){
			for(EmployeeToRole etr :empToRoleList){
				EmployeeToRole.dao.deleteById(etr.getLong("eid"),etr.getLong("rid"));
			}
		}
		//更新eid角色
		EmployeeToRole employeeToRole = new EmployeeToRole();
		for(String rid : ridStrArr){
			if(!"0".equals(rid)){
				employeeToRole.set("eid", Integer.valueOf(eid));
				employeeToRole.set("rid", rid);
				employeeToRole.save();
			}
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
public void getEmployeeTreeCheck(){
		int eid = getParaToInt("eid");
		List<Department> departmentList = Department.dao.find("select did,dname from t_department");
		StringBuffer sb = new StringBuffer();
		sb.append("[ ");
		sb.append("{ \"name\":\"所有可选员工\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"true\"");
		sb.append(",\"children\":[ ");
		int index = 0;
		List<Employee> employeeList = null;
		EmployeeToEmployee ete = null;
		for(Department dt :departmentList){
			sb.append("{ ");
			sb.append("\"name\":\""+dt.getStr("dname")+"\"");
			sb.append(",\"pId\":\""+dt.getLong("did")+"\"");
			sb.append(",\"open\":\"false\"");
			//获取部门下所有部门经理和员工
			int second = 0;
			//获取对应部门下部门经理和部门员工
			employeeList = Employee.dao.find("select e.eid,e.zname from t_employee e "
					+ "INNER JOIN t_employee_role er on er.eid=e.eid "
					+ "INNER JOIN t_role r on er.rid=r.rid "
					+ "WHERE (r.rname like '%普%通%员%工%' or r.rname like '%部%门%经%理%') "
					+ "and e.did="+dt.getLong("did")+" and e.eid!="+eid);
			sb.append(",\"children\":[ ");
			for(Employee ee :employeeList){
				sb.append("{ ");
				sb.append("\"id\":\""+ee.getLong("eid")+"\"");
				sb.append(",\"name\":\""+ee.getStr("zname")+"\"");
				
				ete = EmployeeToEmployee.dao.findById(eid,ee.getLong("eid"));
				if(ete!=null){//如果当前人员有分配角色则加载选中
					sb.append(",\"checked\":\"true\"");
				}
				sb.append("} ");
				if(second<employeeList.size()-1){
					sb.append(",");
				}
				second++;
			}
			sb.append(" ] }");
			if(index<departmentList.size()-1){
				sb.append(",");
			}
			index++;
			
		}
		sb.append("] } ]");
		this.renderJson(sb.toString());
	}
	
	
}
