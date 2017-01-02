package com.tao.www.controller;

import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Department;
import com.tao.www.model.DepartmentType;
import com.tao.www.model.EmployeeToDepartment;

public class DepartmentController extends Controller {

	public void index(){
		this.render("department.jsp");
	}
	
	public void init(){
		List<DepartmentType> departmentTypeList = DepartmentType.dao.find("select dtid,dtname from t_department_type");
		this.renderJson(JsonKit.toJson(departmentTypeList));
	}
	public void getDepartmentList(){
		
		String search = getPara("search");
		int dtid = getParaToInt("dtid");
		String strDtid = "";
		if(dtid!=0){
			strDtid = " and d.dtid="+dtid;
		}
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_department d inner join t_department_type dt ON d.dtid = dt.dtid  where 1=1" +strDtid ;
		}else{
			sqlExpectSelect = "from t_department d inner join t_department_type dt ON d.dtid = dt.dtid where 1=1 and d.dname like '%"+search+"%'"+strDtid;
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<Department> departmentPage = Department.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select * ",
				sqlExpectSelect);
		//System.out.println("第几页:"+(getParaToInt("offset", 0)/getParaToInt("limit", 10)+1)+"===每页条数:"+getParaToInt("limit", 10));
		int total = departmentPage.getTotalRow();
		//DepartmentType.dao.paginate(page, 15, "select *", "from item where" + sqlCondition + " order by id desc"))
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentPage.getList())+"}");
		this.renderJson(sb.toString());
		
		//setAttr("departmentTypePage", departmentTypePage);
		//String json = "  [{ \"id\": 0,\"name\": \"测试0\", \"price\": \"&yen;0\"}]  ";
		//this.renderJson(json);
		//setAttr("departmentTypeList", departmentTypeList);
	}
	
	
	public void addDeparment(){
		Department department = getModel(Department.class);
		//System.out.println(departmentType.getStr("name"));
		department.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateDeparment(){
		Department department = getModel(Department.class);
		//System.out.println(departmentType.getStr("name"));
		department.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeDeparment(){
		int did = getParaToInt("did");
		//System.out.println(departmentType.getStr("name"));
		Department.dao.deleteById(did);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveDeparment(){
		String[] didStrArr = getPara("dids").split(",");
		for(String did : didStrArr){
			Department.dao.deleteById(did);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getDepartmentTree(){
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
		sb.append("{ \"name\":\"所有部门\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"true\"");
		sb.append(",\"children\":[ ");
		int index = 0;
		List<Department> departmentList = null;
		for(DepartmentType dt :departmentTypeList){
			sb.append("{ ");
			sb.append("\"name\":\""+dt.getStr("dtname")+"\"");
			sb.append(",\"pId\":\""+dt.getLong("dtid")+"\"");
			sb.append(",\"open\":\"true\"");
			//获取部门类别下所有部门
			int second = 0;
			departmentList = Department.dao.find("select did,dname from t_department where dtid="+dt.getLong("dtid"));
			sb.append(",\"children\":[ ");
			for(Department d :departmentList){
				sb.append("{ ");
				sb.append("\"id\":\""+d.getLong("did")+"\"");
				sb.append(",\"name\":\""+d.getStr("dname")+"\"");
				sb.append("} ");
				if(second<departmentList.size()-1){
					sb.append(",");
				}
				second++;
			}
			sb.append(" ] }");
			if(index<departmentTypeList.size()-1){
				sb.append(",");
			}
			index++;
			
		}
		sb.append("] } ]");
		this.renderJson(sb.toString());
	}
	
	public void getDepartmentTreeCheck(){
		
		int eid = getParaToInt("eid")==null?0:getParaToInt("eid");
		
		List<DepartmentType> departmentTypeList = DepartmentType.dao.find("select dtid,dtname from t_department_type");
		StringBuffer sb = new StringBuffer();
		sb.append("[ ");
		sb.append("{ \"name\":\"所有部门\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"true\"");
		sb.append(",\"children\":[ ");
		int index = 0;
		List<Department> departmentList = null;
		EmployeeToDepartment etd = null;
		for(DepartmentType dt :departmentTypeList){
			sb.append("{ ");
			sb.append("\"name\":\""+dt.getStr("dtname")+"\"");
			sb.append(",\"pId\":\""+dt.getLong("dtid")+"\"");
			sb.append(",\"open\":\"true\"");
			//获取部门类别下所有部门
			int second = 0;
			departmentList = Department.dao.find("select did,dname from t_department where dtid="+dt.getLong("dtid"));
			sb.append(",\"children\":[ ");
			for(Department d :departmentList){
				sb.append("{ ");
				sb.append("\"id\":\""+d.getLong("did")+"\"");
				sb.append(",\"name\":\""+d.getStr("dname")+"\"");
				etd = EmployeeToDepartment.dao.findById(eid,d.getLong("did"));
				if(etd!=null){//如果当前人员有分配部门则加载选中
					sb.append(",\"checked\":\"true\"");
				}
				sb.append("} ");
				if(second<departmentList.size()-1){
					sb.append(",");
				}
				second++;
			}
			sb.append(" ] }");
			if(index<departmentTypeList.size()-1){
				sb.append(",");
			}
			index++;
			
		}
		sb.append("] } ]");
		this.renderJson(sb.toString());
	}
}
