package com.tao.www.controller;

import java.util.Iterator;
import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.DepartmentResult;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeOption;
import com.tao.www.model.EmployeeQuestionBasic;
import com.tao.www.model.DepartmentType;
import com.tao.www.model.EmployeeResult;
import com.tao.www.model.Role;
import com.tao.www.model.Statistic;

public class EmployeeQuestionBasicController extends Controller {

	public void index(){
		this.render("employeeQuestionBasic.jsp");
	}
	
	public void initDT(){
		List<DepartmentType> departmentTypeList = DepartmentType.dao.find("select dtid,dtname from t_department_type");
		this.renderJson(JsonKit.toJson(departmentTypeList));
	}
	public void initR(){
		List<Role> roleList = Role.dao.find("select rid,rname from t_role where rtype=0 and (rname like '%部%门%经%理%' or rname like '%普%通%员%工%') ");
		this.renderJson(JsonKit.toJson(roleList));
	}
	
	//部门经理测试列表页
	public void eqdList(){
		Statistic sc = (Statistic)getSessionAttr("sc");
		if(sc!=null){
			setAttr("sname", sc.getStr("sname"));
		}else{
			setAttr("sname", "测评未开启");
		}
		this.render("eqdList.jsp");
	}

	//普通员工测评列表页
	public void eqeList(){
		Statistic sc = (Statistic)getSessionAttr("sc");
		if(sc!=null){
			setAttr("sname", sc.getStr("sname"));
		}else{
			setAttr("sname", "测评未开启");
		}
		this.render("eqeList.jsp");
	}

	//部门经理测试列表数据
	public void getEqdList(){
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");//参评人
		String search = getPara("search");
		
		StringBuffer sb = new StringBuffer();
		if(sc!=null&&ee!=null){
			String str2 = "直属副总经理";
			String rName = getSessionAttr("rName");//角色名称
			String sqlExpectSelect = null;
			//当前登录人只有一个直属副总经理角色,就从对应配置表里取他能测评的部门经理
			if(str2.indexOf(rName.trim())>-1){
				StringBuffer tsb = new StringBuffer();
				tsb.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
				   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
				   .append("INNER JOIN t_department d on e.did=d.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
				   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
				   .append("INNER JOIN t_role r on r.rid=er.rid ")
				   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
				   .append(search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":" ")
				   .append(" UNION ")
				   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
				   .append("INNER JOIN t_employee e on ed.did=e.did ")
				   .append("inner join t_department d on e.did=d.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
				   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
				   .append("INNER JOIN t_role r on r.rid=er.rid ")
				   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ed.eid="+ee.getLong("eid"))
				   .append(search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":" "+") aa");
				sqlExpectSelect = tsb.toString();
			}else{
				//其他角色可以测评所有部门经理
				sqlExpectSelect = "from (select e.*,dt.dtid,r.rid,d.dname from t_employee e "
						+ "inner join t_employee_role er on e.eid=er.eid "
						+ "inner join t_department d on d.did=e.did "
						+ "inner join t_department_type dt on dt.dtid=d.dtid "
						+ "inner join t_role r on er.rid=r.rid where r.rname like '%部%门%经%理%' "
						+ "and e.isactive=1 "
						+ (search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":"")+") aa";
			}
			Page<Employee> employeePage = Employee.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select * ",
					sqlExpectSelect);
			int total = employeePage.getTotalRow();
			List<Employee> eeList = employeePage.getList();
			for(Employee e :eeList){
				//然后查询出每个当前用户对当前部门经理是否做出了测评,e为被测经理
				EmployeeResult er = EmployeeResult.dao.findFirst("select * from t_employee_result "
						+ "where sid="+sc.getLong("sid")+" and erothereid="+ee.getLong("eid")+" and eid="
						+e.getLong("eid"));
				if(er!=null){
					e.put("ertotal", er.getFloat("ertotal"));
					e.put("erissubmit", er.getInt("erissubmit"));
					e.put("erid", er.getLong("erid"));
				}else{
					e.put("ertotal", 0.0F);
					e.put("erissubmit", 0);
					e.put("erid", 0);
					
				}
			}
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
		
	}
	
	//普通员工测试列表数据
	public void getEqeList(){
		//这里因为有一个部门树,所以会多两个参数dtid,did
		int did = getParaToInt("did");
		int dtid = getParaToInt("dtid");
		String strDid = "";
		if(did!=0){
			strDid = " and did="+did;
		}
		String strDtid = "";
		if(dtid!=0){
			strDtid = " and dtid="+dtid;
		}
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");//参评人
		String search = getPara("search");
		StringBuffer sb = new StringBuffer();
		if(sc!=null&&ee!=null){
			
			String rName = getSessionAttr("rName");//角色名称
			String sqlExpectSelect = null;
			
			StringBuffer tsb = new StringBuffer();
			//当前登录人是直属副总经理或者部门副经理角色,就从对应配置表里取他能测评的普通员工
			tsb.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
			   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
			   .append("INNER JOIN t_department d on e.did=d.did ")
			   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
			   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
			   .append("INNER JOIN t_role r on r.rid=er.rid ")
			   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
			   .append(search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":" ");
			//如果角色里面还有部门经理或者普通员工角色,则加入该角色对应部门的员工列表
			if(rName.contains("部门经理")||rName.contains("普通员工")){
				tsb.append(" UNION ")
				   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
				   .append("inner join t_employee_role er on e.eid=er.eid  ")
				   .append("inner join t_department d on d.did=e.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
				   .append("inner join t_role r on er.rid=r.rid where r.rname like '%员%工%' ")
				   .append("and e.isactive=1 and d.did="+ee.getLong("did"))
			       .append(search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":"");
			}
		    tsb.append(") aa where 1=1 "+strDid + strDtid);
			sqlExpectSelect = tsb.toString();
			Page<Employee> employeePage = Employee.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select * ",
					sqlExpectSelect);
			int total = employeePage.getTotalRow();
			List<Employee> eeList = employeePage.getList();
			for(Employee e :eeList){
				//然后查询出每个当前用户对当前被测普通员工是否做出了测评,e为被测普通员工
				EmployeeResult er = EmployeeResult.dao.findFirst("select * from t_employee_result "
						+ "where sid="+sc.getLong("sid")+" and erothereid="+ee.getLong("eid")+" and eid="
						+e.getLong("eid"));
				if(er!=null){
					e.put("ertotal", er.getFloat("ertotal"));
					e.put("erissubmit", er.getInt("erissubmit"));
					e.put("erid", er.getLong("erid"));
				}else{
					e.put("ertotal", 0.0F);
					e.put("erissubmit", 0);
					e.put("erid", 0);
					
				}
			}
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
	}
	//部门经理测试题目数据
	public void eqdTest(){
		int dtid = getParaToInt("dtid");//通过角色id 获取角色对应类型题目
		//int rid = getParaToInt("rid");//通过角色id 获取角色对应类型题目
		int eid = getParaToInt("eid");//通过角色id 获取角色对应类型题目
		String rids  = Db.queryStr("select group_concat(rid) from t_role where rname like '%部%门%经%理%' ");
		StringBuffer sb = new StringBuffer();
		sb.append("select * from t_employee_question_standard eqs ")
		  .append("inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid ")
		  .append("where eqb.dtid="+dtid+" and eqb.eqbisactive=1 and eqb.rid in("+rids+") ")
		  .append(" UNION ")
		  .append("select * from t_employee_question_standard eqs ")
		  .append("inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid ")
		  .append("where eqb.eqbiscommon=1  and eqb.eqbisactive=1 and eqb.rid in("+rids+") ");
		//找到所有的测评问题
		List<EmployeeQuestionBasic> employeeQuestionBasicList = EmployeeQuestionBasic.dao.find(sb.toString());
		Iterator<EmployeeQuestionBasic> iter = employeeQuestionBasicList.iterator(); 
		EmployeeQuestionBasic eq = null;
		List<EmployeeOption> employeeOptionList = null;
		EmployeeResult er = null;
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		while(iter.hasNext()){  
			eq = iter.next();  
			employeeOptionList = EmployeeOption.dao.find("select * from  t_employee_option "
					+ "where eqsid="+eq.getLong("eqsid")+" order by eonum asc ");
			
			if(sc!=null&&ee!=null){
				er = EmployeeResult.dao.findFirst("select * from t_employee_result er "
						+ "inner join t_employee_result_detail erd on erd.erid = er.erid where "
						+ "er.erothereid="+ee.getLong("eid")+" and er.sid="+sc.getLong("sid")
						+ " and er.eid="+eid
						+ " and erd.eqsid= "+eq.getLong("eqsid"));
			
				if(er!=null){
					eq.put("eoid",er.getLong("eoid"));
					eq.put("erdweight",er.getLong("erdweight"));
				}
			}
			if(employeeOptionList!=null&&employeeOptionList.size()>0){
				eq.put("employeeOptionList",employeeOptionList);
			}else{
				iter.remove(); //没有选项问题的就移除
			}
		}  
		setAttr("size",employeeQuestionBasicList.size());
		setAttr("employeeQuestionBasicList", employeeQuestionBasicList);
		this.render("eqdTest.jsp");
	}
	
	//普通员工测试题目数据
	public void eqeTest(){
		int dtid = getParaToInt("dtid");//通过角色id 获取角色对应类型题目
		int rid = getParaToInt("rid");//通过角色id 获取角色对应类型题目
		int eid = getParaToInt("eid");//通过角色id 获取角色对应类型题目
		//找到所有的测评问题
		List<EmployeeQuestionBasic> employeeQuestionBasicList = EmployeeQuestionBasic.dao.find(
				"select * from t_employee_question_standard eqs "
						  + "inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid "
						  + "where eqb.dtid="+dtid+" and eqb.eqbisactive=1 and eqb.rid="+rid
						  + " UNION "
						  + "select * from t_employee_question_standard eqs "
						  + "inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid "
						  + "where eqb.eqbiscommon=1 and eqb.eqbisactive=1 and eqb.rid="+rid);
		Iterator<EmployeeQuestionBasic> iter = employeeQuestionBasicList.iterator(); 
		EmployeeQuestionBasic eq = null;
		List<EmployeeOption> employeeOptionList = null;
		EmployeeResult er = null;
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		while(iter.hasNext()){  
			eq = iter.next();  
			employeeOptionList = EmployeeOption.dao.find("select * from  t_employee_option "
					+ "where eqsid="+eq.getLong("eqsid")+" order by eonum asc ");
			
			if(sc!=null&&ee!=null){
				er = EmployeeResult.dao.findFirst("select * from t_employee_result er "
						+ "inner join t_employee_result_detail erd on erd.erid = er.erid where "
						+ "er.erothereid="+ee.getLong("eid")+" and er.sid="+sc.getLong("sid")
						+ " and er.eid="+eid
						+ " and erd.eqsid= "+eq.getLong("eqsid"));
			
				if(er!=null){
					eq.put("eoid",er.getLong("eoid"));
					eq.put("erdweight",er.getLong("erdweight"));
				}
			}
			if(employeeOptionList!=null&&employeeOptionList.size()>0){
				eq.put("employeeOptionList",employeeOptionList);
			}else{
				iter.remove(); //没有选项问题的就移除
			}
		}  
		setAttr("size",employeeQuestionBasicList.size());
		setAttr("employeeQuestionBasicList", employeeQuestionBasicList);
		this.render("eqeTest.jsp");
	}
	
	public void getEmployeeQuestionBasicList(){
		String search = getPara("search");
		int dtid = getParaToInt("dtid");
		String strDtid = "";
		if(dtid>0){
			strDtid = " and eqb.dtid="+dtid+" and eqbiscommon=0";
		}else if(dtid<0){
			strDtid = " and eqbiscommon=1";
		}
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_employee_question_basic eqb "
					+ "inner join t_department_type dt ON eqb.dtid = dt.dtid "
					+ "inner join t_role r ON eqb.rid = r.rid  where 1=1" +strDtid ;
		}else{
			sqlExpectSelect = "from t_employee_question_basic eqb "
					+ "inner join t_department_type dt ON eqb.dtid = dt.dtid "
					+ "inner join t_role r ON eqb.rid = r.rid where 1=1 and "
					+ "eqb.dqbasic like '%"+search+"%'"+strDtid;
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<EmployeeQuestionBasic> employeeQuestionBasicPage = EmployeeQuestionBasic.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select * ",
				sqlExpectSelect);
		int total = employeeQuestionBasicPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeeQuestionBasicPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addEmployeeQuestionBasic(){
		EmployeeQuestionBasic employeeQuestionBasic = getModel(EmployeeQuestionBasic.class);
		//System.out.println(departmentType.getStr("name"));
		employeeQuestionBasic.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void editEmployeeQuestionBasic(){
		EmployeeQuestionBasic employeeQuestionBasic = getModel(EmployeeQuestionBasic.class);
		employeeQuestionBasic.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateEmployeeQuestionBasic(){
		int eqbid = getParaToInt("eqbid");
		int eqbisactive = getParaToInt("eqbisactive");
		//修改当前状态,停用时将问题及其对应选项分值置0
		if(eqbisactive==0){
			EmployeeQuestionBasic.dao.findById(eqbid)
			.set("eqbisactive", eqbisactive)
			.set("eqbscale", 0)
			.update();
			Db.update("update t_employee_question_standard set eqsscale=0 where eqbid="+eqbid);
		}else{
			EmployeeQuestionBasic.dao.findById(eqbid).set("eqbisactive", eqbisactive).update();
		}
		
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeEmployeeQuestionBasic(){
		int eqbid = getParaToInt("eqbid");
		//System.out.println(departmentType.getStr("name"));
		EmployeeQuestionBasic.dao.deleteById(eqbid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveEmployeeQuestionBasic(){
		String[] eqbidStrArr = getPara("eqbids").split(",");
		for(String eqbid : eqbidStrArr){
			EmployeeQuestionBasic.dao.deleteById(eqbid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
}
