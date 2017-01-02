package com.tao.www.controller;

import java.util.Iterator;
import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Department;
import com.tao.www.model.DepartmentOption;
import com.tao.www.model.DepartmentQuestion;
import com.tao.www.model.DepartmentResult;
import com.tao.www.model.DepartmentType;
import com.tao.www.model.Employee;
import com.tao.www.model.Statistic;

public class DepartmentQuestionController extends Controller {

	public void index(){
		this.render("departmentQuestion.jsp");
	}
	
	public void init(){
		List<DepartmentType> departmentTypeList = DepartmentType.dao.find("select dtid,dtname from t_department_type");
		this.renderJson(JsonKit.toJson(departmentTypeList));
	}
	
	public void dqList(){
		Statistic sc = (Statistic)getSessionAttr("sc");
		if(sc!=null){
			setAttr("sname", sc.getStr("sname"));
		}else{
			setAttr("sname", "测评未开启");
		}
		this.render("dqList.jsp");
	}
	
	public void getDqList(){
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		int dtid = getParaToInt("dtid");
		String search = getPara("search");
		StringBuffer sb = new StringBuffer();
		if(sc!=null&&ee!=null){
			String strDtid = "";
			if(dtid!=0){
				strDtid = " and d.dtid="+dtid;
			}
			String str2 = "直属副总经理";
			String rName = getSessionAttr("rName");//角色名称
			String sqlExpectSelect = null;
			//当前登录人只有一个直属副总经理角色,就从对应配置表里取他能测评的部门
			if(str2.indexOf(rName.trim())>-1){
				sqlExpectSelect = " from t_employee_department ed "
						+ "inner join t_department d on ed.did=d.did where ed.eid= "+ee.getLong("eid")
						+strDtid +(search!=null&&search.length()>0?" and d.dname like '%"+search+"%'":"");
			}else{
				sqlExpectSelect = "from t_department d where 1=1 "
						+ strDtid +(search!=null&&search.length()>0?" and d.dname like '%"+search+"%'":""
						+ " and d.dname not like '%高管%'");
			}
			Page<Department> departmentPage = Department.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select * ",
					sqlExpectSelect);
			int total = departmentPage.getTotalRow();
			List<Department> dtList = departmentPage.getList();
			for(Department dt :dtList){
				//然后查询出每个当前用户对当前部门是否做出了测评
				DepartmentResult dtr = DepartmentResult.dao.findFirst("select * from t_department_result "
						+ "where sid="+sc.getLong("sid")+" and eid="+ee.getLong("eid")+" and did="
						+dt.getLong("did"));
				if(dtr!=null){
					dt.put("drtotal", dtr.getFloat("drtotal"));
					dt.put("drissubmit", dtr.getInt("drissubmit"));
					dt.put("drid", dtr.getLong("drid"));
				}else{
					dt.put("drtotal", 0.0F);
					dt.put("drissubmit", 0);
					dt.put("drid", 0);
					
				}
			}
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentPage.getList())+"}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
	
	}
	
	public void dqTest(){
		int dtid = getParaToInt("dtid");
		int did = getParaToInt("did");
		//找到当前部门类型的测评问题
		List<DepartmentQuestion> departmentQuestionList = DepartmentQuestion.dao.find("select * from  t_department_question "
				+ "where dtid="+dtid+" and dqisactive=1 order by dqid asc");
		Iterator<DepartmentQuestion> iter = departmentQuestionList.iterator(); 
		DepartmentQuestion dq = null;
		List<DepartmentOption> departmentOptionList = null;
		DepartmentResult drd = null;
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		while(iter.hasNext()){  
			dq = iter.next();  
			departmentOptionList = DepartmentOption.dao.find("select * from  t_department_option "
					+ "where dqid="+dq.getLong("dqid")+" order by donum asc ");
			//根据对应的问题找到对应的答案
			if(sc!=null&&ee!=null){
				drd = DepartmentResult.dao.findFirst("select * from t_department_result dr "
						+ "inner join t_department_result_detail drd on drd.drid = dr.drid where "
						+ "dr.eid="+ee.getLong("eid")+" and dr.sid="+sc.getLong("sid")
						+ " and dr.did="+did
						+ " and drd.dqid= "+dq.getLong("dqid"));
			
				if(drd!=null){
					dq.put("doid",drd.getLong("doid"));
					dq.put("drdweight",drd.getLong("drdweight"));
				}
			}
			if(departmentOptionList!=null&&departmentOptionList.size()>0){
				dq.setDepartmentOptionList(departmentOptionList);
			}else{
				iter.remove(); //没有选项问题的就移除
			}
			
		}  
		setAttr("size",departmentQuestionList.size());
		setAttr("departmentQuestionList", departmentQuestionList);
		this.render("dqTest.jsp");
	}
	
	public void getDepartmentQuestionList(){
		String search = getPara("search");
		int dtid = getParaToInt("dtid");
		String strDtid = "";
		if(dtid!=0){
			strDtid = " and dq.dtid="+dtid;
		}
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_department_question dq inner join t_department_type dt ON dq.dtid = dt.dtid  where 1=1" +strDtid ;
		}else{
			sqlExpectSelect = "from t_department_question dq inner join t_department_type dt ON dq.dtid = dt.dtid where 1=1 and "
					+ "(dq.dqbasic like '%"+search+"%' or "+"dq.dqstandard like '%"+search+"%')"+strDtid;
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<DepartmentQuestion> departmentQuestionPage = DepartmentQuestion.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select * ",
				sqlExpectSelect);
		int total = departmentQuestionPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentQuestionPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addDepartmentQuestion(){
		DepartmentQuestion departmentQuestion = getModel(DepartmentQuestion.class);
		//System.out.println(departmentType.getStr("name"));
		departmentQuestion.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void editDepartmentQuestion(){
		DepartmentQuestion departmentQuestion = getModel(DepartmentQuestion.class);
		//System.out.println(departmentType.getStr("name"));
		departmentQuestion.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateDepartmentQuestion(){
		int dqid = getParaToInt("dqid");
		int dqisactive = getParaToInt("dqisactive");
		//修改当前状态,停用时将问题及其对应选项分值置0
		if(dqisactive==0){
			DepartmentQuestion.dao.findById(dqid)
			.set("dqisactive", dqisactive)
			.set("dqscale", 0)
			.update();
		}else{
			DepartmentQuestion.dao.findById(dqid).set("dqisactive", dqisactive).update();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeDepartmentQuestion(){
		int dqid = getParaToInt("dqid");
		//System.out.println(departmentType.getStr("name"));
		DepartmentQuestion.dao.deleteById(dqid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveDepartmentQuestion(){
		String[] dqidStrArr = getPara("dqids").split(",");
		for(String dqid : dqidStrArr){
			DepartmentQuestion.dao.deleteById(dqid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getRemainNum(){
		int dtid = getParaToInt("dtid");
		int dqid = getParaToInt("dqid");
		Number rNum = Db.queryNumber("select SUM(dqscale) rNum from t_department_question where dtid=" + dtid
				+" and dqid!=" + dqid);
		int nowNum = 100;
		if(rNum!=null){
			System.out.println("rNum"+rNum.intValue());
			nowNum = nowNum -rNum.intValue();
			System.out.println("nowNum"+nowNum);
		}
		this.renderJson("{\"remainNum\":"+nowNum+"}");
	}
	
}
